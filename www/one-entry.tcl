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

set write_p [permission::permission_p -object_id $package_id -privilege write]

if { [empty_string_p $return_url] } {
    set return_url "[ad_conn url]?[ad_conn query]"
}

set show_poster_p [ad_parameter "ShowPosterP" "" "1"]

lars_blogger::entry::get -entry_id $entry_id -array blog

set page_title $blog(title)

if {![exists_and_not_null screen_name]} {
    set screen_name ""
    set context_bar [ad_context_bar $page_title]
} else {
    set context_bar [ad_context_bar $screen_name]
}

set header_background_color [lars_blog_header_background_color]

# Load the StylesheetURL into $stylesheet_url
regsub \% [lars_blog_stylesheet_url] [ad_conn package_url] stylesheet_url

ad_return_template
