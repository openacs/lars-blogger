set package_id [ad_conn package_id]

if [empty_string_p $screen_name] {
    db_multirow -extend { url } months all_blog_months { *SQL* } {
	set url "[ad_conn package_url]archive/$month_url_stub"
    }
} else {
    db_multirow -extend { url } months one_blog_months { *SQL* } {
	set url "[ad_conn package_url]user/$screen_name/archive/$month_url_stub"
    }
}

ad_return_template
