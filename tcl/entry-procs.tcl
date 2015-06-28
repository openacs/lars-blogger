ad_library {
    Entry procs for blogger.
}

namespace eval lars_blogger {}
namespace eval lars_blogger::entry {}

ad_proc -public lars_blogger::entry::new {
    {-entry_id ""}
    {-package_id ""}
    {-title:required}
    {-title_url ""}
    {-category_id ""}
    {-content ""}
    {-content_format "text/plain"}
    {-entry_date ""}
    {-draft_p "t"}
} {
	Add the blog entry and then flush the cache so that the new entry shows up.
} {
    set creation_user [ad_conn user_id]
    set creation_ip [ns_conn peeraddr]

    if { $package_id eq "" } {
        set package_id [ad_conn package_id]
    }

    db_transaction {
        # Create the entry
        set entry_id [db_exec_plsql entry_add {}]
        lars_blog_flush_cache $package_id
    }

    # If publish directly, fire off notifications and ping weblogs.com
    if { ![template::util::is_true $draft_p] } {
        lars_blogger::entry::publish \
            -entry_id $entry_id \
            -package_id $package_id \
            -no_update
    }

    lars_blog_flush_cache $package_id

    return $entry_id
}

ad_proc -public lars_blogger::entry::edit {
    {-entry_id:required}
    {-title:required}
    {-title_url ""}
    {-category_id ""}
    {-content:required}
    {-content_format:required}
    {-entry_date:required}
    {-draft_p:required}
} {
    Edit the blog entry and then optionally perform notifications 
    and RSS operations if the blog was a draft before and now is 
    being published.
    
    @param entry_date Date of the entry in full ANSI format (YYYY-MM-DD HH24:MI:SS)

    @return entry_id of edited entry

    @author Vinod Kurup vinod@kurup.com
    @creation-date 2003-10-04
} {
    # Get old values first -- need draft_p and package_id
    lars_blogger::entry::get -entry_id $entry_id -array entry
    
    db_dml update_entry {}
            
    # Is this a publish?
    if { [template::util::is_true $draft_p] && ![template::util::is_true $entry(draft_p)] } {
	lars_blogger::entry::publish -entry_id $entry_id -package_id $entry(package_id)
    } else {
        # Update instance/user feeds if needed
        lars_blog_setup_feed -package_id $entry(package_id)
    }
    
    lars_blog_flush_cache $entry(package_id)

    return $entry_id
}

ad_proc -public lars_blogger::entry::get { 
    -entry_id:required
    -array:required
} {
    Get a blog entry. Also sets entry_date_pretty, package_url, permalink_url entries.
} {
    # Select the info into the upvar'ed Tcl Array
    upvar $array row

    if {![db_0or1row select_entry {} -column_array row]} {
        error "lars_blogger::entry::get: entry $entry_id not found" {} NOT_FOUND
    }

    set row(entry_date_pretty) [lc_time_fmt $row(entry_date_ansi) "%q %X"]
    set row(package_url) [lars_blog_public_package_url -package_id $row(package_id)]
    set row(permalink_url) [export_vars -base "${row(package_url)}one-entry" { entry_id }]
}

ad_proc -public lars_blogger::entry::publish {
    {-entry_id:required}
    {-package_id ""}
    {-no_update:boolean}
    {-redirect_url ""}
} {
    if { $package_id eq "" } {
	# can't just use ad_conn package_id since the 
	# request may be coming via XML-RPC
	lars_blogger::entry::get -entry_id $entry_id -array entry
	set package_id $entry(package_id)
    }

    if { !$no_update_p } {
        # Set draft_p = 'f'
        db_dml update_entry {}
        # Flush cache
        lars_blog_flush_cache
    }
    
    if { $redirect_url ne "" } {
        ad_returnredirect $redirect_url
        ns_conn close
    }
    
    # Setup instance/user feeds if needed
    lars_blog_setup_feed -package_id $package_id
    
    # Notifications
    lars_blogger::entry::do_notifications -entry_id $entry_id

    # Ping weblogs.com
    lars_blogger::instance::send_pings -package_id $package_id

    # trackback
    lars_blogger::entry::trackback -entry_id $entry_id
}


ad_proc -public lars_blogger::entry::draft {
    {-entry_id:required}
} { 
    Mark a blog entry as drafted
} {
    permission::require_write_permission -object_id $entry_id
    db_dml delete {
        update pinds_blog_entries
        set    draft_p = 't'
        where  entry_id = :entry_id
    }
    lars_blog_flush_cache
}

ad_proc -public lars_blogger::entry::delete {
    {-entry_id:required}
} { 
    Delete a blog entry
} {
    permission::require_write_permission -object_id $entry_id
    db_dml delete {
        update pinds_blog_entries
        set    deleted_p = 't'
        where  entry_id = :entry_id
    }
    lars_blog_flush_cache
}


ad_proc -public lars_blogger::entry::htmlify { 
    {-ellipsis "..."}
    {-more ""}
    {-max_content_length 0}
    -array:required
} {
    Make the entry displayable in an HTML page

    @see ad_html_text_convert
} {
    upvar $array row

    set row(title) $row(title)

    # LARS:
    # Not sure we should do the ns_adp_parse thing here, but heck, why not
    # It should be safe, given the standard HTML filter security checks, which 
    # wouldn't let unsafe tags slip through, anyway
    
    set row(content) [ad_html_text_convert -from $row(content_format) -to "text/html" -- $row(content)]
    
    set row(entry_date_pretty) [lc_time_fmt $row(entry_date_ansi) "%q %X"]

    # We wrap this in a catch so if it bombs, at least we won't break any pages
    catch {
        set row(content) [ns_adp_parse -string $row(content)]
    }

    set row(content) [util_close_html_tags $row(content) $max_content_length $max_content_length $ellipsis $more]

    # look for the base site name in the url
    if { [regexp {^https?://([^ /]+)} $row(title_url) initial base_url] } {
        set row(title_url_base) $base_url
    } else {
        set row(title_url_base) {}
    }
}




ad_proc -public lars_blogger::entry::do_notifications {
    {-entry_id:required}
} {
    # Select all the important information
    get -entry_id $entry_id -array blog

    set blog_url "[ad_url][lars_blog_public_package_url -package_id $blog(package_id)]"
    set entry_url [export_vars -base "[ad_url][lars_blog_public_package_url -package_id $blog(package_id)]one-entry" { entry_id }]
    set blog_name [lars_blog_name -package_id $blog(package_id)]

    set new_content ""

    append new_content "$blog_name: $blog_url<p>"

    if { $blog(title_url) ne "" } {
        append new_content "<a href=\"$blog(title_url)\">$blog(title)</a>"
    } else {
	append new_content "$blog(title)"
    }
    append new_content "<br>[string repeat "-" [string length $blog(title)]]<p>"

    append new_content "$blog(content)<p>"
    append new_content "$blog(entry_date_pretty) by $blog(poster_first_names) $blog(poster_last_name)<p>"

    append new_content "Permalink: $entry_url<br>"
    append new_content "$blog_name: $blog_url<br>"

    append new_content "This entry: $entry_url<br>"
    
    # Do the notification for the forum
    notification::new \
        -type_id [notification::type::get_type_id \
        -short_name lars_blogger_notif] \
        -object_id $blog(package_id) \
        -response_id $blog(entry_id) \
        -notif_subject $blog(title) \
        -notif_html $new_content
}

ad_proc lars_blogger::entry::trackback { -entry_id } {
    sends trackback ping (if enabled)
} {

    if {[parameter::get -parameter EnableAutoDiscoveryAndPing -default "1"]} {

	lars_blogger::entry::get -entry_id $entry_id -array entry
	set url [ad_url][pinds_blog_entry__url $entry_id]
	set excerpt [string range $entry(content) 0 [parameter::get -parameter TrackbackMaxExcerpt -default 200]]
	set blog_name [lars_blog_name -package_id $entry(package_id)]

	ns_log debug "Trackback sending: url=$url title=$entry(title) excerpt=$excerpt content=$entry(content) blog_name=$blog_name"
	trackback::auto_ping -url $url \
                -title $entry(title) \
		-excerpt $excerpt \
                -content "$entry(title_url) $entry(content)" \
                -blog_name $blog_name

    }

}

ad_proc -public lars_blogger::entry::get_comments {
    -entry_id
    {-multirow "comments"}
} {
    @param entry_id
    @param multirow
    upvars a multirow in the caller to display comments
} {

    set content_select [db_map content_select] ;# ", r.content"
    upvar $multirow $multirow 
    db_multirow -extend { pretty_date pretty_date2 } $multirow get_comments {} {
	set pretty_date [lc_time_fmt $creation_date_ansi "%x"]
	set pretty_date2 [lc_time_fmt $creation_date_ansi "%q %X"]
    }
}
