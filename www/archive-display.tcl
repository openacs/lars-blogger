ad_page_contract {} {
    year:notnull,string_length_range(4|4)
    month:notnull,string_length_range(2|2)
    day:optional,string_length_range(2|2)
}

set package_id [ad_conn package_id]

set package_url [lars_package_url_from_package_id $package_id]

set admin_p [ad_permission_p $package_id admin]

set page_title "[db_string package_name { *SQL* }] Archive"

if { [empty_string_p $day] } {

    set interval "month"

    db_1row archive_date_month { *SQL* }

    set context_bar [ad_context_bar [list "${package_url}archive/" "Archive"] $archive_date_pretty]

} else {

    set interval "day"

    db_1row archive_date_month_day { *SQL* }

    set context_bar [ad_context_bar [list "${package_url}archive/" "Archive"] $archive_date_pretty]

}

ad_return_template