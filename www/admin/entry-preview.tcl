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

set show_poster_p [ad_parameter "ShowPosterP" "" "1"]

lars_blogger::entry::get -entry_id $entry_id -array blog

ad_return_template