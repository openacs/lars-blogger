# Expects:
# blog:onerow
# show_comments_p:boolean
# return_url:onevalue,optional
# package_id:optional
# screen_name:onevalue,optional
# perma_p: 1/0 (defaults to 0 -- set to 1 if this is the permalink page)
# max_content_length:integer,optional

# Nested multirows!

# Get the name of the multirow contained in sw_category_multirow column
set mrname $blog(sw_category_multirow)

# The following command will create a locally bound multirow pointing to
# the nested multirow.  The name we fetched above refers to the level of
# the template we are included from.
template::multirow -local -ulevel 1 upvar $mrname sw_category_multirow

if { ![info exists perma_p] || $perma_p eq "" } {
    set perma_p 0
}
if { ![info exists show_comments_p] || $show_comments_p eq "" } {
    set show_comments_p $perma_p
}


# Maybe package_id is supplied, but maybe not
if { ![info exists package_id] } {
    set package_id [ad_conn package_id]
}

if { ![info exists return_url] || $return_url eq "" } {
    set return_url [ad_return_url]
}
if { ![info exists screen_name] } {
    set screen_name ""
}

if { ![info exists max_content_length] || $max_content_length eq "" } {
    set max_content_length 0
}        

set package_url [lars_blog_public_package_url -package_id $package_id]

set user_id [ad_conn user_id]

set general_comments_package_url [general_comments_package_url]

set show_poster_p [parameter::get -parameter "ShowPosterP" -default "1"]

set entry_id $blog(entry_id)

if { $screen_name eq "" } {
    set blog(permalink_url) [export_vars -base ${package_url}one-entry { entry_id }]
} else {
    set blog(permalink_url) [export_vars -base ${package_url}user/$screen_name/one-entry { entry_id }]
}

lars_blogger::entry::htmlify \
    -max_content_length $max_content_length \
    -more [ad_decode [ad_return_url] $blog(permalink_url) {} "<br><a href=\"$blog(permalink_url)\">(more)</a>"] \
    -array blog


set blog(edit_url) [export_vars -base "${package_url}entry-edit" { entry_id return_url }]
set blog(delete_url) [export_vars -base "${package_url}entry-delete" { entry_id return_url }]

set blog(publish_url) [export_vars -base "${package_url}entry-publish" { entry_id return_url }]
set blog(revoke_url) [export_vars -base "${package_url}entry-revoke" { entry_id return_url }]

set blog(write_p) [permission::write_permission_p \
                       -object_id $blog(entry_id) \
                       -creation_user $blog(user_id) \
                       -party_id [ad_conn untrusted_user_id]]

set display_categories [lars_blog_categories_p \
                            -package_id [ad_conn package_id]]

if { [template::util::is_true $show_comments_p] } {
    lars_blogger::entry::get_comments -entry_id $entry_id
    set blog(comment_add_url) [export_vars -base "${general_comments_package_url}comment-add" {
	{ object_id $entry_id }
	{ object_name $blog(title) }
	{ return_url "[export_vars -base ${package_url}flush-cache { return_url }]"}
    }]
}

set blog(posted_time_pretty) [util::age_pretty \
                                 -timestamp_ansi $blog(entry_date_ansi) \
                                 -sysdate_ansi $blog(sysdate_ansi)]
