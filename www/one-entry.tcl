ad_page_contract {} {
    entry_id:integer
    {return_url ""}
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

if { [empty_string_p $return_url] } {
    set return_url "[ad_conn url]?[ad_conn query]"
}

db_1row entry { *SQL* }

set page_title $title

set context_bar [ad_context_bar $page_title]

set title_html [ad_quotehtml $title]
set content [ns_adp_parse -string $content]
set content_html [ad_quotehtml $content]
set entry_date_html [ad_quotehtml $entry_date]
set draft_p_checked [ad_decode $draft_p "t" "checked" ""]

set edit_url "[ad_conn package_url]admin/entry-edit?[export_vars -url { entry_id return_url }]"
set delete_url "[ad_conn package_url]admin/entry-delete?[export_vars -url { entry_id return_url }]"

set publish_url "[ad_conn package_url]admin/entry-publish?[export_vars -url { entry_id return_url }]"
set revoke_url "[ad_conn package_url]admin/entry-revoke?[export_vars -url { entry_id return_url }]"

set comments_html [general_comments_get_comments -print_content_p 1 $entry_id]

set comment_add_url "[general_comments_package_url]comment-add?[export_vars -url { { object_id $entry_id } { object_name $title } { return_url "[ad_conn package_url]flush-cache?[export_vars -url { return_url }]"} }]"

ad_return_template