ad_library {
     Procs used by the blogger module.
     @author Lars Pind (lars@pinds.com)
     @creation-date 2002
     @cvs-id $Id$
}

ad_proc -public lars_blog_entry_add {
    {-entry_id:required}
    {-package_id:required}
    {-title:required}
    {-title_url ""}
    {-content:required}
    {-content_format:required}
    {-entry_date:required}
    {-draft_p:required}
} {
	Add the blog entry and then flush the cache so that the new entry shows up.
} {
    set creation_user [ad_conn user_id]
    set creation_ip [ns_conn peeraddr]

    set entry_id [db_exec_plsql entry_add { *SQL* }]

    # If publish directly
    if { [string equal $draft_p "f"] } {
        # do notifications
        lars_blogger::entry::do_notifications -entry_id $entry_id
        # and ping weblogs.com
        lars_blog_weblogs_com_update_ping
    }

    lars_blog_flush_cache $package_id

    return $entry_id
}



ad_proc -private lars_blog_get_as_string_mem { 
    package_id
    admin_p
} {
    return [template::adp_parse "[acs_package_root_dir "lars-blogger"]/www/blog" [list package_id $package_id]]
}

    
ad_proc -public lars_blog_get_as_string { 
    -package_id
    -url
} {
    if { ![exists_and_not_null package_id] } {
        array set blog_site_node [site_node $url]
        set package_id $blog_site_node(object_id)
    }
    set admin_p [ad_permission_p $package_id admin]
    return [util_memoize "lars_blog_get_as_string_mem $package_id $admin_p" 600]
}

ad_proc lars_blog_flush_cache {
    {package_id ""}
} {
    if { [empty_string_p $package_id] } {
        set package_id [ad_conn package_id]
    }
    # Flush both admin and non-admin version
    util_memoize_flush "lars_blog_get_as_string_mem $package_id 0"
    util_memoize_flush "lars_blog_get_as_string_mem $package_id 1"
}

ad_proc -public lars_blog_public_package_url {
    -package_id
} {
    if { ![exists_and_not_null package_id] } {
        # No package_id given, so we'll just use ad_conn
        set package_id [ad_conn package_id]
        set default_url [ad_conn package_url]
    } else {
        if { [catch { 
            # This will fail if the package has been mounted on more than one URL ... hm.
            set default_url [apm_package_url_from_id $package_id]
        }] } { 
            # In that case, we'll just hope that they set up the parameter
            set default_url ""
        }
    }
    return [ad_parameter -package_id $package_id "public_url" "lars-blogger" $default_url] 
}

ad_proc -public lars_blog_name { 
    -package_id
} {
    if { ![exists_and_not_null package_id] } {
        set package_id [ad_conn package_id]
    }
    array set site_node [site_node::get_from_object_id -object_id $package_id]
    return $site_node(instance_name)
}

ad_proc -public lars_blog_header_background_color {
    -package_id
} {
    if { ![exists_and_not_null package_id] } {
        set package_id [ad_conn package_id]
    }
    return [ad_parameter -package_id $package_id "HeaderBackgroundColor" "lars-blogger" "#dcdcdc"] 
}
