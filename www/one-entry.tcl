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

set show_poster_p [ad_parameter "ShowPosterP" "" "1"]

db_1row entry { *SQL* } -column_array blog

set page_title $blog(title)

set context_bar [ad_context_bar $page_title]

set blog(title) [ad_quotehtml $blog(title)]
set blog(content) [ns_adp_parse -string $blog(content)]
set blog(draft_p_checked) [ad_decode $blog(draft_p) "t" "checked" ""]

set blog(edit_url) "[ad_conn package_url]admin/entry-edit?[export_vars -url { entry_id return_url }]"
set blog(delete_url) "[ad_conn package_url]admin/entry-delete?[export_vars -url { entry_id return_url }]"

set blog(publish_url) "[ad_conn package_url]admin/entry-publish?[export_vars -url { entry_id return_url }]"
set blog(revoke_url) "[ad_conn package_url]admin/entry-revoke?[export_vars -url { entry_id return_url }]"

set blog(entry_archive_url) "[ad_conn package_url]one-entry?[export_vars { entry_id }]"
set blog(google_url) "http://www.google.com/search?[export_vars { {q $blog(title) } }]"


set comments_html [general_comments_get_comments -print_content_p 1 $entry_id]

set blog(comment_add_url) "[general_comments_package_url]comment-add?[export_vars -url { { object_id $entry_id } { object_name $blog(title) } { return_url "[ad_conn package_url]flush-cache?[export_vars -url { return_url }]"} }]"

ad_return_template