set package_id [ad_conn package_id]

db_multirow -extend { url } months months { *SQL* } {
    set url "[ad_conn package_url]archive/$month_url_stub"
}

ad_return_template