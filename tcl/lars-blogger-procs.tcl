ad_library {
     Procs used by the blogger module.
     @author Lars Pind (lars@pinds.com)
     @creation-date 2002
     @cvs-id $Id$
}

namespace eval lars_blogger {}

namespace eval lars_blogger::merge {

    ad_proc -callback MergeShowUserInfo -impl lars_blogger {
	-user_id:required
    } {
	Show the items of user_id
    } {
	set msg "Lars_blogger items of $user_id"
	set result [list $msg]

	set channels [db_list_of_lists sel_channels { *SQL* }]
	lappend result $channels
	
	return $result
    }

    ad_proc -callback MergePackageUser -impl lars_blogger {
	-from_user_id:required
	-to_user_id:required
    } {
	Merge the entries of two users.

	The from_user_id is the user_id of the user
	that will be deleted and all the entries
	of this user will be mapped to the to_user_id.
	
    } {
	set msg "Merging lars_blogger"
	ns_log Notice $msg
	set result [list $msg]

	db_dml upd_channels { *SQL* }
	
	lappend result "Merge of lars_blogger is done"
	
	return $result
    }
}



ad_proc lars_blog_setup_feed {
    -user:boolean
    {-package_id ""}
} {
    if { [empty_string_p $package_id] } {
        set package_id [ad_conn package_id]
    }
    
    set timeout [expr 30*60]
    set channel_title [lars_blog_name -package_id $package_id]
    set creation_user [ad_conn user_id]
    set creation_ip [ns_conn peeraddr]
    
    # Package feed
    if { [parameter::get -parameter "package_rss_feed_p" -package_id $package_id -default 1] } {
        
        # check whether there's been a channel setup for this instance
        set summary_context_id [db_string select_instance_channel {} -default {}]
            
        if { [empty_string_p $summary_context_id] } {
            # Setup a channel for this instance
            set summary_context_id [db_exec_plsql create_instance_channel {}]
        }
        
        # check whether there's been a feed setup for this instance
        set subscr_id [db_string instance_feed_subscr_id {} -default {}]
        
        if { [empty_string_p $subscr_id] } {
            # Setup an RSS feed for this instance
            set channel_link [lars_blog_public_package_url]
            
            set subscr_id [db_exec_plsql create_subscr {}]
            db_dml update_subscr {}
        }
        # Run it now
        rss_gen_report $subscr_id
    }

    if { [parameter::get -parameter "user_rss_feed_p" -package_id $package_id -default 0] } {

        # check whether there's been a channel setup for this instance
        set summary_context_id [db_string select_user_channel {} -default {}]

        if { [empty_string_p $summary_context_id] } {
            # Setup a channel for this instance
            set summary_context_id [db_exec_plsql create_user_channel {}]
        }

        # check whether there's been a feed setup for this user
        set subscr_id [db_string user_feed_subscr_id {} -default {}]

        if { [empty_string_p $subscr_id] } {
            set screen_name [acs_user::get_element -user_id $creation_user -element screen_name]
            
            if { ![empty_string_p $screen_name] } {
                # Setup an RSS feed for the user
                set channel_link "[lars_blog_public_package_url]user/$screen_name/"
                
                set subscr_id [db_exec_plsql create_subscr {}]
                db_dml update_subscr {}
            } else {
                ns_log Warning "lars-blogger: User $creation_user has no screen_name, cannot setup an RSS feed for user"
            }
        }
        if { ![empty_string_p $subscr_id] } {
            # Run it now
            rss_gen_report $subscr_id
        }
    }
}

ad_proc -private lars_blog_get_as_string_mem { 
    package_id
    create_p
    display_template
} {
    return [template::adp_parse "[acs_package_root_dir "lars-blogger"]/www/blog" [list package_id $package_id create_p $create_p display_template $display_template]]
}


ad_proc -public lars_blog_get_as_string { 
    -package_id
    -url
    {-display_template /packages/lars-blogger/www/blog}
} {
    Return the blog entries as a string (which is memoized and cached
    for 10 minutes).

    provide either url (like /blog) or package_id

    display_template is what to use to render the blog (instead of
    the default blog.adp).
} { 
    if { ![exists_and_not_null package_id] } {
        array set blog_site_node [site_node::get -url $url]
        set package_id $blog_site_node(object_id)
    }
    set create_p [ad_permission_p $package_id create]
    return [util_memoize [list lars_blog_get_as_string_mem $package_id $create_p $display_template] 600]
}

ad_proc lars_blog_flush_cache {
    {package_id ""}
} {
    if { [empty_string_p $package_id] } {
        set package_id [ad_conn package_id]
    }
    # Flush both admin and non-admin version
    util_memoize_flush_regexp "lars_blog_get_as_string_mem $package_id"
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

ad_proc -public lars_blog_categories_p {
    -package_id
} {
    if { ![exists_and_not_null package_id] } {
        set package_id [ad_conn package_id]
    }
    return [ad_parameter -package_id $package_id "EnableCategoriesP" "lars-blogger" "1"]
}

ad_proc -public lars_blog_stylesheet_url {
    -package_id
} {
    if { ![exists_and_not_null package_id] } {
        set package_id [ad_conn package_id]
    }
    return [parameter::get -package_id $package_id -parameter "StylesheetURL" -default "/resources/lars-blogger/lars-blogger.css"] 
}

ad_proc -public lars_blog_list_user_blogs {
    user_id
} {
    Return list of package_ids of blogs on which user has 'create' permission

    @param user_id user_id
    @return list of package_id
    @author Vinod Kurup <vinod@kurup.com>
} {
    return [db_list blog_list {}]
}

ad_proc -public lars_blogger::count {
    -package_id
} {
    @return the number of published blog entries in the package.
} {
    if { ![exists_and_not_null package_id] } {
        set package_id [ad_conn package_id]
    }
    return [db_string entry_count {}]
}


ad_proc -public lars_blogger::get_rss_file_url {
    -package_id
    -screen_name
} {
    @param package_id The package_id of the lars-blogger instance. Defaults to current package.
    
    @param screen_name If specified, returns the RSS feed for just that user's postings.
    
    @return The URL of the RSS feed.
} {
    if { ![exists_and_not_null package_id] } {
        set package_id [ad_conn package_id]
    }

    set rss_file_url {}
    
    set rss_file_name [parameter::get -parameter "rss_file_name" -package_id $package_id]

    if { ![empty_string_p $rss_file_name] } {
        set package_url [lars_blog_public_package_url -package_id $package_id]

        if { [exists_and_not_null screen_name] } {
            set rss_file_url "${package_url}user/$screen_name/rss/$rss_file_name"
        } else {
            set rss_file_url "${package_url}rss/$rss_file_name"
        }
    }
    return $rss_file_url
}
