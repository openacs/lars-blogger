ad_page_contract {} {
} -properties {
    context_bar
}

set package_id [ad_conn package_id]

set admin_p [ad_require_permission $package_id admin]

set page_title "Recently Published Entries"

set context_bar [ad_context_bar $page_title]

db_multirow entries entries { *SQL* } {
    set return_url "[ad_conn url][ad_decode [ad_conn query] "" "" "?[ad_conn query]"]"
    set edit_url "[ad_conn package_url]admin/entry-edit?[export_vars -url { entry_id return_url }]"
}

ad_return_template
