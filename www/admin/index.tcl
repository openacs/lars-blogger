ad_page_contract {} {
} -properties {
    context_bar
}

set package_id [ad_conn package_id]

set admin_p [permission::require_permission -object_id $package_id -privilege admin]

set context [list]

set title "[_ lars-blogger.Administration]"

set return_url [ad_return_url]

set parameters_url [export_vars -base "/shared/parameters" { package_id return_url }]

set arrow_url "[lars_blog_public_package_url -package_id $package_id]graphics/arrow-box.gif"

set categories [lars_blog_categories_p -package_id $package_id]

set permission_url "[export_vars -base "/permissions/one" {return_url {object_id $package_id}}]"

set category_map_url [export_vars -base \
    "[site_node::get_package_url -package_key categories]cadmin/one-object" \
                          { { object_id {[ad_conn [parameter::get -parameter CategoryContainer -default package_id]]} } }]

set instance_feed_p [db_string rss_feed_p {}]
set rss_setup_url "rss-setup"

set rss_manage_url "[apm_package_url_from_key "rss-support"]my-subscrs"

if { [parameter::get -parameter "rss_file_name"] ne "" } {
    set rss_file_url "[ad_conn package_url]rss/[parameter::get -parameter "rss_file_name"]"
}
