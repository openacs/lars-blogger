#
# Expects:
# date:onevalue,optional
#

if { ![info exist date] } {
    set date [dt_sysdate]
}

dt_get_info $date

# first_julian_date
# last_julian_date

set calendar_details [ns_set create calendar_details]

set package_url [lars_blog_public_package_url]
set month_number [clock format [clock scan $date] -format %m]

set package_id [ad_conn package_id]

if {[empty_string_p $screen_name]} {
    db_foreach all_entry_dates { * SQL * } {
	ns_set put $calendar_details $entry_date_julian "1"
    }
} else {
    db_foreach entry_dates { * SQL * } {
	ns_set put $calendar_details $entry_date_julian "1"
    }
}

if {[empty_string_p $screen_name]} {

    set day_number_template "\[ad_decode \[ns_set get \$calendar_details \$julian_date\] 1 \"<a href=\\\"${package_url}archive/\$year/$month_number/\[format \"%02d\" \$day_number\]/\\\" title=\\\"View the entries for this date\\\"><b>\$day_number</b></a>\" \$day_number\]"

} else {

     set day_number_template "\[ad_decode \[ns_set get \$calendar_details \$julian_date\] 1 \"<a href=\\\"${package_url}user/$screen_name/archive/\$year/$month_number/\[format \"%02d\" \$day_number\]/\\\" title=\\\"View the entries for this date\\\"><b>\$day_number</b></a>\" \$day_number\]"

}

set widget [dt_widget_month_small \
        -date $date \
        -calendar_details $calendar_details \
        -day_number_template $day_number_template]

if {[empty_string_p $screen_name]} {

    set prev_month_url "${package_url}archive/[clock format [clock scan $prev_month] -format %Y/%m]/"
    set next_month_url "${package_url}archive/[clock format [clock scan $next_month] -format %Y/%m]/"

} else {

    set prev_month_url "${package_url}user/$screen_name/archive/[clock format [clock scan $prev_month] -format %Y/%m]/"
    set next_month_url "${package_url}user/$screen_name/archive/[clock format [clock scan $next_month] -format %Y/%m]/"

}
# Add year to the link
append next_month_name " [string range $next_month 0 3]"
append prev_month_name " [string range $prev_month 0 3]"
