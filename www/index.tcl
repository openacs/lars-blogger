ad_page_contract {} {
} -properties {
    context_bar
    page_title
}

set package_id [ad_conn package_id]

set context_bar [ad_context_bar]

set page_title [db_string package_name { *SQL* }]

if { ![empty_string_p [ad_parameter "rss_file_url"]] } {
    set rss_file_url "[ad_url][ad_parameter "rss_file_url"]"
}

ad_return_template
