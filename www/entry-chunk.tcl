# Expects:
# blog:onerow
# show_comments_p:boolean
# retrun_url:onevalue,optional
# package_id:optional
# screen_name:onevalue,optional
# perma_p: 1/0 (defaults to 0 -- set to 1 if this is the permalink page)

if { ![exists_and_not_null perma_p] } {
    set perma_p 0
}
if { ![exists_and_not_null show_comments_p] } {
    set show_comments_p $perma_p
}


# Maybe package_id is supplied, but maybe not
if { ![info exists package_id] } {
    set package_id [ad_conn package_id]
}

if { ![exists_and_not_null return_url] } {
    set return_url "[ad_conn url]?[ad_conn query]"
}
if { ![exists_and_not_null screen_name] } {
    set screen_name ""
}

set package_url [lars_blog_public_package_url -package_id $package_id]

set user_id [ad_conn user_id]

set general_comments_package_url [general_comments_package_url]

set show_poster_p [ad_parameter "ShowPosterP" "" "1"]

lars_blogger::entry::htmlify -array blog

set entry_id $blog(entry_id)

set blog(edit_url) "${package_url}entry-edit?[export_vars { entry_id return_url }]"
set blog(delete_url) "${package_url}entry-delete?[export_vars { entry_id return_url }]"

set blog(publish_url) "${package_url}entry-publish?[export_vars { entry_id return_url }]"
set blog(revoke_url) "${package_url}entry-revoke?[export_vars { entry_id return_url }]"

set blog(write_p) [permission::write_permission_p -object_id $blog(entry_id) -creation_user $blog(user_id) -party_id [ad_conn untrusted_user_id]]

if { [empty_string_p $screen_name] } {
    set blog(permalink_url) "${package_url}one-entry?[export_vars { entry_id }]"
} else {
    set blog(permalink_url) "${package_url}user/$screen_name/one-entry?[export_vars { entry_id }]"
}

set display_categories [lars_blog_categories_p -package_id [ad_conn package_id]]

if { [template::util::is_true $show_comments_p] } {
    lars_blogger::entry::get_comments -entry_id $entry_id
    set blog(comment_add_url) "${general_comments_package_url}comment-add?[export_vars { { object_id $entry_id } { object_name $blog(title) } { return_url "${package_url}flush-cache?[export_vars { return_url }]"} }]"
}

if { $blog(category_id) != 0 } {
    set category_url "${package_url}"
    if { [exists_and_not_null screen_name] } {
	append category_url "user/$screen_name"
    }
    append category_url "/cat/$blog(category_short_name)"
}

