ad_library {
    Entry procs for blogger.
}

namespace eval lars_blogger::entry {}

ad_proc -public lars_blogger::entry::get { 
    -entry_id:required
    -array:required
} {
    # Select the info into the upvar'ed Tcl Array
    upvar $array row

    db_1row select_entry {} -column_array row 
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
    append new_content "$blog(title)\n\n"
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
