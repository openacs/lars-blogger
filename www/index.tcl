ad_page_contract {} {
} -properties {
    context_bar
    page_title
}

set context_bar [ad_context_bar]

set page_title [lars_blog_name]

if { ![empty_string_p [ad_parameter "rss_file_url"]] } {
    set rss_file_url "[ad_url][ad_parameter "rss_file_url"]"
}

set notification_chunk [notification::display::request_widget \
    -type lars_blogger_notif \
    -object_id [ad_conn package_id] \
    -pretty_name [lars_blog_name] \
    -url [lars_blog_public_package_url] \
]

ad_return_template