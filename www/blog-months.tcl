set package_id [ad_conn package_id]

set package_url [lars_package_url_from_package_id $package_id]

db_multirow months months { *SQL* } {
    set url "${package_url}archive/$month_url_stub"
}

ad_return_template