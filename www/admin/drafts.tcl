ad_page_contract {} {
} -properties {
    context_bar
}

set package_id [ad_conn package_id]

set admin_p [ad_require_permission $package_id admin]

set page_title "Draft Entries"

set context [list $page_title]

db_multirow -extend { edit_url publish_url delete_url preview_url } draft_entries draft_entries {} {
    set return_url "[ad_conn url][ad_decode [ad_conn query] "" "" "?[ad_conn query]"]"
    set edit_url "[ad_conn package_url]admin/entry-edit?[export_vars { entry_id return_url }]"
    set delete_url "[ad_conn package_url]admin/entry-delete?[export_vars { entry_id return_url }]"
    set preview_url "[ad_conn package_url]one-entry?[export_vars { entry_id return_url }]"
    set publish_url "[ad_conn package_url]admin/entry-publish?[export_vars { entry_id return_url }]"
}

for { set i 1 } { $i <= ${draft_entries:rowcount} } { incr i } {
    lars_blogger::entry::htmlify -array "draft_entries:$i"
}


set entry_add_url "entry-edit"

set arrow_url "[ad_conn package_url]graphics/arrow-box.gif"

set header_background_color [lars_blog_header_background_color]


