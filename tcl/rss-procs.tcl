ad_library {
     Procs used by the to set up the rss service contract for the blogger module.
     @author Lars Pind
     @creation-date 
     @cvs-id $Id$
}

ad_proc -private lars_blog__rss_datasource {
    package_id
} {
    This procedure implements the "datasource" operation of the
    RssGenerationSubscriber service contract.  

    @author Lars Pind (lars@pinds.com)
} {
    set blog_title [db_string package_name { *SQL* }]

    set blog_url "[ad_url][ad_parameter -package_id $package_id "public_url" "lars-blogger" [lars_package_url_from_package_id $package_id]]"
    
    set column_array(channel_title) $blog_title
    set column_array(channel_description) $blog_title
    set column_array(channel_pubDate) [db_string now { *SQL* }]

    set column_array(version) 1.00

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

    db_foreach blog_rss_items { *SQL* } {
        set entry_url "[ad_url][lars_package_url_from_package_id $package_id]archive/${entry_archive_url}#blog-entry-$entry_id"

        set content [ns_adp_parse -string $content]

        regsub -all {<[^>]*>} $content {} content_as_text

        set truncate_len 100
        if { [string length $content_as_text] > $truncate_len } {
            set description "[string range $content_as_text 0 [expr {$truncate_len-3}]]..."
        } else {
            set description $content_as_text
        }

        lappend items [list link $entry_url title $title description $description value $content timestamp "${posted_date_string}T${posted_time_string}-0600"]
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
    package_id
} {
    Returns the time that the last blog entry was posted,
    in Unix time.  Returns 0 otherwise.

    @author Lars Pind (lars@pinds.com)
} {
    db_0or1row get_last_update {
        select coalesce (date_part('epoch',max(posted_date)),0) as last_update
        from   pinds_blog_entries
        where  package_id = :package_id
        and    draft_p = 'f'
        and    deleted_p = 'f'
    }

    return $last_update
}


