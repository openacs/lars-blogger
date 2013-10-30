if { ![info exists package_id] } {
    set package_id [ad_conn package_id]
}
set package_url [lindex [site_node::get_url_from_object_id -object_id $package_id] 0]

if {$screen_name eq ""} {
    db_multirow -extend { url } months all_blog_months { *SQL* } {
	set url "${package_url}archive/$month_url_stub"
    }
} else {
    db_multirow -extend { url } months one_blog_months { *SQL* } {
	set url "${package_url}user/$screen_name/archive/$month_url_stub"
    }
}

ad_return_template
