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

set context [list]
set context_base_url [ad_conn package_url]

if { ![empty_string_p $screen_name] } {
    # Show Screen Name in context bar
    append context_base_url /user/$screen_name
    lappend context [list $context_base_url $screen_name]

    append package_url_with_extras user/$screen_name/
}

if { ![empty_string_p $category_short_name] } {
    if { ![db_0or1row get_category_from_short_name {}] } {
	ad_return_error "Category doesn't exist" "The specified category wasn't valid."
	return
    }
    # Show Category in context bar
    append context_base_url /category/$category_short_name
    lappend context [list $context_base_url $category_name]
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


set create_p [permission::permission_p -object_id $package_id -privilege read]
set admin_p [permission::permission_p -object_id $package_id -privilege admin]

set display_users_p [parameter::get -parameter "DisplayUsersP" -default 0]
set display_categories [lars_blog_categories_p -package_id $package_id]

if {$display_users_p && ![exists_and_not_null screen_name]} {

    set display_bloggers_p 1

    db_multirow bloggers bloggers {}

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
    -object_id $package_id \
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
    lappend context [list $context_base_url Archive]
    append context_base_url /$year
    lappend context [list $context_base_url $year]
    append context_base_url /$month
    lappend context [list $context_base_url $month]


    if { [exists_and_not_null day] } {
        set interval "day"
        db_1row archive_date_month_day {}

	# Day in context
	append context_base_url /$day
	lappend context [list $context_base_url $day]
    } else {
        set interval "month"
        db_1row archive_date_month {}
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

db_multirow categories categories {}

# Cut the URL off the last item in the context bar
if { [llength $context] > 0 } {
    set context [lreplace $context end end [lindex [lindex $context end] end]]
}

set stylesheet_url [lars_blog_stylesheet_url]

