ad_page_contract {
    The Weblogger index page.

    @author Lars Pind (lars@pinds.com)
    @creation-date February 2002
} {
    year:optional,string_length_range(4|4)
    month:optional,string_length_range(2|2)
    day:optional,string_length_range(2|2)
} -properties {
    context_bar
    page_title
}

set context_bar [ad_context_bar]

set page_title [lars_blog_name]

if { ![empty_string_p [ad_parameter "rss_file_url"]] } {
    set rss_file_url "[ad_url][lars_blog_public_package_url][ad_parameter "rss_file_url"]"
}

set admin_p [ad_permission_p [ad_conn package_id] admin]

if { [catch {
    set notification_chunk [notification::display::request_widget \
                                -type lars_blogger_notif \
                                -object_id [ad_conn package_id] \
                                -pretty_name [lars_blog_name] \
                                -url [lars_blog_public_package_url]]
}] } {
    set notification_chunk {}
}

set header_background_color [lars_blog_header_background_color]

if { [exists_and_not_null year] } {
    if { ![exists_and_not_null month] } {
        ad_return_complaint 1 "<li>You must specify both year and month."
        ad_script_abort
    }
    
    if { [exists_and_not_null day] } {
        set interval "day"
        db_1row archive_date_month_day { *SQL* }
        set context_bar [ad_context_bar [list "[ad_conn package_url]archive/" "Archive"] [list "[ad_conn package_url]archive/$year/$month/" $archive_month_pretty] $archive_date_pretty]
    } else {
        set interval "month"
        db_1row archive_date_month { *SQL* }
        set context_bar [ad_context_bar [list "[ad_conn package_url]archive/" "Archive"] $archive_date_pretty]
    }

    append page_title " Archive"
    set date "$year-$month-[ad_decode $day "" "01" $day]"
    set type "archive"

} else {
    set date ""
    set type "current"
    set interval ""
    set archive_date ""
}

ad_return_template
