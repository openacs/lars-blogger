ad_page_contract {
    The Weblogger index page.

    @author Lars Pind (lars@pinds.com)
    @creation-date February 2002
} {
    screen_name:optional
    year:optional,string_length_range(4|4)
    month:optional,string_length_range(2|2)
    day:optional,string_length_range(2|2)
}

set page_title [lars_blog_name]

if {![exists_and_not_null screen_name]} {
    set screen_name ""
    set context_bar [ad_context_bar]
} else {
    set context_bar [ad_context_bar $screen_name]
}

if { ![empty_string_p [parameter::get -parameter "rss_file_name"]] } {

    if {[exists_and_not_null screen_name]} {
        set rss_file_url "[ad_url][lars_blog_public_package_url]user/$screen_name/rss/[parameter::get -parameter "rss_file_name"]"
    } else {
        set rss_file_url "[ad_url][lars_blog_public_package_url]rss/[parameter::get -parameter "rss_file_name"]"
    }

}

set package_id [ad_conn package_id]

set package_url [ad_conn package_url]

set write_p [permission::permission_p -object_id $package_id -privilege write]
set admin_p [permission::permission_p -object_id $package_id -privilege admin]

set display_users_p [parameter::get -parameter "DisplayUsersP" -default 0]

if {$display_users_p && ![exists_and_not_null screen_name]} {

    set display_bloggers_p 1

    db_multirow bloggers bloggers { *SQL* }

    ad_return_template

} else {

    set display_bloggers_p 0

}

set notification_chunk [notification::display::request_widget \
    -type lars_blogger_notif \
    -object_id [ad_conn package_id] \
    -pretty_name [lars_blog_name] \
    -url [lars_blog_public_package_url] \
]

set header_background_color [lars_blog_header_background_color]

if { [exists_and_not_null year] } {
    if { ![exists_and_not_null month] } {
        ad_return_complaint 1 "<li>You must specify both year and month."
        ad_script_abort
    }
    
    if { [exists_and_not_null day] } {
        set interval "day"
        db_1row archive_date_month_day { *SQL* }
	if {[empty_string_p $screen_name]} {
	    set context_bar [ad_context_bar [list "$package_url/archive/" "Archive"] [list "$package_url/archive/$year/$month/" $archive_month_pretty] $archive_date_pretty]
	} else {
	    set context_bar [ad_context_bar [list "$package_url/user/$screen_name/" "$screen_name"] [list "$package_url/user/$screen_name/archive/" "Archive"] [list "$package_url/user/$screen_name/archive/$year/$month/" $archive_month_pretty] $archive_date_pretty]
	}
    } else {
        set interval "month"
        db_1row archive_date_month { *SQL* }
	if {[empty_string_p $screen_name]} {
	    set context_bar [ad_context_bar [list "$package_url/archive/" "Archive"] $archive_date_pretty]
	} else {
	    set context_bar [ad_context_bar [list "$package_url/user/$screen_name/" "$screen_name"] [list "$package_url/user/$screen_name/archive/" "Archive"] $archive_date_pretty]
	}
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
