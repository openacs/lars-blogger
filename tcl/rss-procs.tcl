ad_library {
     Procs used by the to set up the rss service contract for the blogger module.
     @author Lars Pind
     @creation-date 
     @cvs-id $Id$
}

ad_proc -private lars_blog__rss_datasource {
    summary_context_id
} {
    This procedure implements the "datasource" operation of the
    RssGenerationSubscriber service contract.  

    @author Lars Pind (lars@pinds.com)
} {

    db_transaction {
        
        db_1row select_package_id_user_id {}
        
        set package_url [lars_blog_public_package_url -package_id $package_id]
        
        set blog_title [db_string package_name {}]

        set blog_url "[ad_url]$package_url"
        
    }

    set column_array(channel_title) $blog_title
    set column_array(channel_description) $blog_title

    set column_array(version) 2.0

    set column_array(channel_link) $blog_url

    set image_url [ad_parameter -package_id $package_id "channel_image_url"]
    if { [empty_string_p $image_url] } {
        set column_array(image) ""
    } else {
        set column_array(image) [list \
                url "[ad_url]$image_url" \
                title $blog_title \
                link $blog_url \
                width [ad_parameter -package_id $package_id "channel_image_width"] \
                height [ad_parameter -package_id $package_id "channel_image_height"]]
    }

    set items [list]
    set counter 0


    if { [empty_string_p $user_id] } {
        set statement "blog_rss_items" 
    } else {
        set statement "user_blog_rss_items"
    }

    db_foreach $statement {} {
        set entry_url [export_vars -base "[ad_url]${package_url}one-entry" { entry_id }]

        set content [ns_adp_parse -string $content]

        regsub -all {<[^>]*>} $content {} content_as_text

        set truncate_len 100
        if { [string length $content_as_text] > $truncate_len } {
            set description "[string range $content_as_text 0 [expr {$truncate_len-3}]]..."
        } else {
            set description $content_as_text
        }

        # Always convert timestamp to GMT
        set posted_time_ansi [lc_time_tz_convert -from [lang::system::timezone] -to "Etc/GMT" -time_value $posted_time_ansi]
        set entry_timestamp "[clock format [clock scan $posted_time_ansi] -format "%a, %d %b %Y %H:%M:%S"] GMT"

        lappend items [list \
                           link $entry_url \
                           title $title \
                           description $description \
                           value $content \
                           timestamp $entry_timestamp]
        
        if { $counter == 0 } {
            set column_array(channel_lastBuildDate) $entry_date_pretty
            incr counter
        }
    }
    set column_array(items) $items
    set column_array(channel_language)               ""
    set column_array(channel_copyright)              ""
    set column_array(channel_managingEditor)         ""
    set column_array(channel_webMaster)              ""
    set column_array(channel_rating)                 ""
    set column_array(channel_skipDays)               ""
    set column_array(channel_skipHours)              ""

    return [array get column_array]
}

ad_proc -private lars_blog__rss_lastUpdated {
    summary_context_id
} {
    Returns the time that the last blog entry was posted,
    in Unix time.  Returns 0 otherwise.

    @author Lars Pind (lars@pinds.com)
} {

    db_1row select_package_id_user_id {}

    if { [empty_string_p $user_id] } {
        db_0or1row get_last_update {}
    } else {
        db_0or1row get_last_user_update {}
    }

    return $last_update
}
