ad_page_contract {} {
    year:notnull,string_length_range(4|4)
    month:notnull,string_length_range(2|2)
    day:optional,string_length_range(2|2)
}

set package_id [ad_conn package_id]

set admin_p [ad_permission_p [ad_conn package_id] admin]

set page_title "[db_string package_name { *SQL* }] Archive"

if { [empty_string_p $day] } {

    set interval "month"

    db_1row archive_date_month { *SQL* }

    set context_bar [ad_context_bar [list "[ad_conn package_url]archive/" "Archive"] $archive_date_pretty]

} else {

    set interval "day"

    db_1row archive_date_month_day { *SQL* }

    set context_bar [ad_context_bar [list "[ad_conn package_url]archive/" "Archive"] [list "[ad_conn package_url]archive/$year/$month/" $archive_month_pretty] $archive_date_pretty]

}

set date "$year-$month-[ad_decode $day "" "01" $day]"

set notification_chunk [notification::display::request_widget \
    -type lars_blogger_notif \
    -object_id [ad_conn package_id] \
    -pretty_name [lars_blog_name] \
    -url [lars_blog_public_package_url] \
]

ad_return_template