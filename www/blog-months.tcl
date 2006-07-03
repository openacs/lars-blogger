if {![exists_and_not_null package_id]} {
    set package_id [ad_conn package_id]
}

if [empty_string_p $screen_name] {
    db_multirow -extend { url } months all_blog_months { *SQL* } {
	set url "[apm_package_url_from_id $package_id]archive/$month_url_stub"
    }
} else {
    db_multirow -extend { url } months one_blog_months { *SQL* } {
	set url "[apm_package_url_from_id $package_id]user/$screen_name/archive/$month_url_stub"
    }
}

ad_return_template
