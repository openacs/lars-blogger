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

    if { [empty_string_p $package_id] } {
        set package_id [ad_conn package_id]
    }

    db_transaction {
        # Create the entry
        set entry_id [db_exec_plsql entry_add {}]
        lars_blog_flush_cache $package_id
    }

    # If publish directly, fire off notifications and ping weblogs.com
    if { [string equal $draft_p "f"] } {
        lars_blogger::entry::publish \
            -entry_id $entry_id \
            -package_id $package_id \
            -no_update
    }

    return $entry_id
}

ad_proc -public lars_blogger::entry::get { 
    -entry_id:required
    -array:required
} {
    # Select the info into the upvar'ed Tcl Array
    upvar $array row

    db_1row select_entry {} -column_array row 

    # If there's a category set up for the entry, we need to fill the array with the proper information.
    if { $row(category_id) > 0 } {
        set category_id $row(category_id)
        db_1row select_category { *SQL* }
        set row(category_name) $category_name
        set row(category_short_name) $category_short_name
    }
}

ad_proc -public lars_blogger::entry::publish {
    {-entry_id:required}
    {-package_id ""}
    {-no_update:boolean}
    {-redirect_url ""}
} {
    if { !$no_update_p } {
        # Set draft_p = 'f'
        db_dml update_entry {}
        # Flush cache
        lars_blog_flush_cache
    }
    
    if { ![empty_string_p $redirect_url] } {
        ad_returnredirect $redirect_url
        ns_conn close
    }
    
    # Setup instance/user feeds if needed
    lars_blog_setup_feed -package_id $package_id
    
    # Notifications
    lars_blogger::entry::do_notifications -entry_id $entry_id
    
    # Ping weblogs.com
    lars_blog_weblogs_com_update_ping

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
    -array:required
} {
    Make the entry displayable in an HTML page
} {
    upvar $array row

    set row(title) [ad_quotehtml $row(title)]

    # LARS:
    # Not sure we should do the ns_adp_parse thing here, but heck, why not
    # It should be safe, given the standard HTML filter security checks, which 
    # wouldn't let unsafe tags slip through, anyway
    
    set row(content) [ad_html_text_convert -from $row(content_format) -to "text/html" -- $row(content)]
    
    # We wrap this in a catch so if it bombs, at least we won't break any pages
    catch {
        set row(content) [ns_adp_parse -string $row(content)]
    }
    
    # look for the base site name in the url
    if {[regexp {^https?://([^ /]+)} $row(title_url) initial base_url] } {
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
    set entry_url "[ad_url][lars_blog_public_package_url -package_id $blog(package_id)]one-entry?[export_vars { entry_id }]"
    set blog_name [lars_blog_name -package_id $blog(package_id)]

    set new_content ""
    append new_content "$blog(poster_first_names) $blog(poster_last_name) posted to $blog_name at $blog(posted_time_pretty) on $blog(entry_date_pretty):\n\n"
    append new_content "$blog(title)\n[string repeat "-" [string length $blog(title)]]\n"
    if { ![empty_string_p $blog(title_url)] } {
        append new_content "$blog(title_url)\n"
    }
    append new_content "\n"
    append new_content "[ad_convert_to_text -- [ns_adp_parse -string $blog(content)]]\n\n"
    append new_content "This entry: $entry_url\n\n"
    append new_content "$blog_name: $blog_url\n"

    # Do the notification for the forum
    notification::new \
        -type_id [notification::type::get_type_id \
        -short_name lars_blogger_notif] \
        -object_id $blog(package_id) \
        -response_id $blog(entry_id) \
        -notif_subject $blog(title) \
        -notif_text $new_content
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
                -content $entry(content) \
                -blog_name $blog_name

    }

}

ad_proc -public lars_blogger::entry::get_comments {
    -entry_id
    {-multirow "comments"}
} {
    @ param entry_id
    @ param multirow
    upvars a multirow in the caller to display comments
} {

    set content_select [db_map content_select] ;# ", r.content"
    upvar $multirow $multirow 
    db_multirow $multirow get_comments ""

}
