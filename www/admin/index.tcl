ad_page_contract {} {
} -properties {
    context_bar
}

set package_id [ad_conn package_id]

set admin_p [ad_require_permission $package_id admin]

set context_bar [ad_context_bar]

set title [db_string package_name { *SQL* }]

set parameters_url "/admin/site-map/parameter-set?[export_vars { package_id }]"

set arrow_url "[lars_blog_public_package_url -package_id $package_id]graphics/arrow-box.gif"

set rss_feed_p [db_string rss_feed_p {}]

set rss_setup_url "rss-setup"

set rss_manage_url "[apm_package_url_from_key "rss-support"]my-subscrs"

if { ![empty_string_p [parameter::get -parameter "rss_file_url"]] } {
    set rss_file_url "[ad_url][lars_blog_public_package_url][parameter::get -parameter "rss_file_url"]"
}
