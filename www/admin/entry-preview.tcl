ad_page_contract {} {
    entry_id:integer
    return_url:optional
} -properties {
    context_bar
    title_html
    content_html
    draft_p_checked
    entry_date_html
    form_export_vars
    return_url
}

set package_id [ad_conn package_id]

set admin_p [ad_permission_p $package_id admin]

set page_title "Preview Blog Entry"

set context_bar [ad_context_bar $page_title]

db_1row entry { *SQL* }

set title_html [ad_quotehtml $title]
set content [ns_adp_parse -string $content]
set content_html [ad_quotehtml $content]
set entry_date_html [ad_quotehtml $entry_date]
set draft_p_checked [ad_decode $draft_p "t" "checked" ""]

set edit_url "[ad_conn package_url]admin/entry-edit?[export_vars -url { entry_id return_url }]"
set delete_url "[ad_conn package_url]admin/entry-delete?[export_vars -url { entry_id return_url }]"

set publish_url "entry-publish?[export_vars -url { entry_id return_url }]"
set revoke_url "entry-revoke?[export_vars -url { entry_id return_url }]"


ad_return_template