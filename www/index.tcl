ad_page_contract {
    The Weblogger index page.

    @author Lars Pind (lars@pinds.com)
    @creation-date February 2002
} {
    {screen_name:optional {}}
    {category_short_name:optional {}}
    year:optional,string_length_range(4|4)
    month:optional,string_length_range(2|2)
    day:optional,string_length_range(2|2)
}

set page_title [lars_blog_name]

set package_id [ad_conn package_id]

set package_url [ad_conn package_url]
set package_url_with_extras $package_url

set l_context_bar [list]
set context_base_url [ad_conn package_url]

if { ![empty_string_p $screen_name] } {
    # Show Screen Name in context bar
    append context_base_url /user/$screen_name
    lappend l_context_bar [list $context_base_url $screen_name]

    append package_url_with_extras user/$screen_name/
}

if { ![empty_string_p $category_short_name] } {
    if { ![db_0or1row get_category_from_short_name { *SQL* }] } {
	ad_return_error "Category doesn't exist" "The specified category wasn't valid."
	return
    }
    # Show Category in context bar
    append context_base_url /category/$category_short_name
    lappend l_context_bar [list $context_base_url $category_name]
} else {
    set category_id ""
}

if { ![empty_string_p [parameter::get -parameter "rss_file_name"]] } {

    if {[exists_and_not_null screen_name]} {
        set rss_file_url "[ad_conn package_url]user/$screen_name/rss/[parameter::get -parameter "rss_file_name"]"
    } else {
        set rss_file_url "[ad_conn package_url]rss/[parameter::get -parameter "rss_file_name"]"
    }

}


set write_p [permission::permission_p -object_id $package_id -privilege write]
set admin_p [permission::permission_p -object_id $package_id -privilege admin]

set display_users_p [parameter::get -parameter "DisplayUsersP" -default 0]
set display_categories [lars_blog_categories_p -package_id $package_id]

if {$display_users_p && ![exists_and_not_null screen_name]} {

    set display_bloggers_p 1

    db_multirow bloggers bloggers { *SQL* }

    set user_has_blog_p 0
    multirow foreach bloggers {
        if { $user_id == [ad_conn user_id] } {
            set user_has_blog_p 1
            break
        }
    }

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
    
    # Show Archive, Year and Month i context
    append context_base_url /archive
    lappend l_context_bar [list $context_base_url Archive]
    append context_base_url /$year
    lappend l_context_bar [list $context_base_url $year]
    append context_base_url /$month
    lappend l_context_bar [list $context_base_url $month]


    if { [exists_and_not_null day] } {
        set interval "day"
        db_1row archive_date_month_day { *SQL* }

	# Day in context
	append context_base_url /$day
	lappend l_context_bar [list $context_base_url $day]
    } else {
        set interval "month"
        db_1row archive_date_month { *SQL* }
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

db_multirow categories categories { *SQL* }

# Cut the URL off the last item in the context bar
set l_context_bar [lreplace $l_context_bar end end [lindex [lindex $l_context_bar end] end]]
eval "set context_bar \[ad_context_bar $l_context_bar\]"

# Load the StylesheetURL into $stylesheet_url
regsub \% [lars_blog_stylesheet_url] $package_url stylesheet_url

ad_return_template
