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

ad_return_template