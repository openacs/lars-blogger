ad_page_contract {} {
} -properties {
    context_bar
}

set package_id [ad_conn package_id]

set admin_p [ad_require_permission $package_id admin]

set context_bar [ad_context_bar]

set title [db_string package_name { *SQL* }]

ad_return_template

