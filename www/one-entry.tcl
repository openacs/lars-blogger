ad_page_contract {} {
    entry_id:integer
    {return_url ""}
} -properties {
    context
    blog:onerow
    header_background_color
    page_title
}

set package_id [ad_conn package_id]

set admin_p [ad_permission_p $package_id admin]

if { [empty_string_p $return_url] } {
    set return_url "[ad_conn url]?[ad_conn query]"
}

lars_blogger::entry::get -entry_id $entry_id -array blog

set page_title $blog(title)

set context [list $page_title]

set header_background_color [lars_blog_header_background_color]

ad_return_template
