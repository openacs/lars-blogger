ad_page_contract {} {
} -properties {
    context_bar
}

set package_id [ad_conn package_id]

set admin_p [ad_require_permission $package_id admin]

set page_title "Draft Entries"

set context_bar [ad_context_bar $page_title]

db_multirow draft_entries draft_entries { *SQL* } {
    set return_url "[ad_conn url][ad_decode [ad_conn query] "" "" "?[ad_conn query]"]"
    set edit_url "[ad_conn package_url]admin/entry-edit?[export_vars -url { entry_id return_url }]"
    set delete_url "[ad_conn package_url]admin/entry-delete?[export_vars -url { entry_id return_url }]"
    set preview_url "[ad_conn package_url]admin/entry-preview?[export_vars -url { entry_id return_url }]"
    set content [ns_adp_parse -string $content]
}

set entry_add_url "entry-edit"

ad_return_template

