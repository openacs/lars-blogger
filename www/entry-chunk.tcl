# Expects:
# blog:onerow
# show_comments_p:onevalue,optional
# retrun_url:onevalue,optional
# package_id:optional

if { ![exists_and_not_null show_comments_p] } {
    set show_comments_p "f"
}

# Maybe package_id is supplied, but maybe not
if { ![info exists package_id] } {
    set package_id [ad_conn package_id]
}

set admin_p [ad_permission_p $package_id admin]

if { ![exists_and_not_null return_url] } {
    set return_url "[ad_conn url]?[ad_conn query]"
}

set package_url [lars_blog_public_package_url -package_id $package_id]

set general_comments_package_url [general_comments_package_url]

set show_poster_p [ad_parameter "ShowPosterP" "" "1"]

set blog(title) [ad_quotehtml $blog(title)]

# LARS:
# Not sure we should do the ns_adp_parse thing here, but heck, why not
# It should be safe, given the security checks
set blog(content) [ns_adp_parse -string [ad_html_text_convert -from $blog(content_format) -to "text/html" $blog(content)]]

set entry_id $blog(entry_id)

set blog(edit_url) "${package_url}admin/entry-edit?[export_vars { entry_id return_url }]"
set blog(delete_url) "${package_url}admin/entry-delete?[export_vars { entry_id return_url }]"

set blog(publish_url) "${package_url}admin/entry-publish?[export_vars { entry_id return_url }]"
set blog(revoke_url) "${package_url}admin/entry-revoke?[export_vars { entry_id return_url }]"

set blog(entry_archive_url) "${package_url}one-entry?[export_vars { entry_id }]"
set blog(google_url) "http://www.google.com/search?[export_vars { {q $blog(title) } }]"

if { ![empty_string_p $general_comments_package_url] } {
    set blog(comment_add_url) "${general_comments_package_url}comment-add?[export_vars { { object_id $entry_id } { object_name $blog(title) } { return_url "${package_url}flush-cache?[export_vars { return_url }]"} }]"
}

set blog(comments_view_url) "${package_url}one-entry?[export_vars { entry_id }]"

if { [string equal $show_comments_p "t"] } {
    set comments_html [general_comments_get_comments -print_content_p 1 $entry_id]
}

ad_return_template