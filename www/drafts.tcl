ad_page_contract {} {
} -properties {
    context_bar
}

set package_id [ad_conn package_id]

set user_id [ad_conn user_id]

if { [ad_permission_p $package_id admin] } {
    set statement "all_draft_entries"
} else {
    set statement "draft_entries"
}

set page_title "Draft Entries"

set context [list $page_title]

db_multirow -extend { edit_url publish_url delete_url preview_url } draft_entries $statement {} {
    set return_url "[ad_conn url][ad_decode [ad_conn query] "" "" "?[ad_conn query]"]"
    set edit_url "[ad_conn package_url]entry-edit?[export_vars { entry_id return_url }]"
    set delete_url "[ad_conn package_url]entry-delete?[export_vars { entry_id return_url }]"
    set preview_url "[ad_conn package_url]one-entry?[export_vars { entry_id return_url }]"
    set publish_url "[ad_conn package_url]entry-publish?[export_vars { entry_id return_url }]"
}

set entry_add_url "entry-edit"

set arrow_url "[ad_conn package_url]graphics/arrow-box.gif"

set header_background_color [lars_blog_header_background_color]


