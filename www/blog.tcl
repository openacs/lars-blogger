# Expects:
#  package_id:optional
#  url:optional
#  type:optional (current, archive)
#  archive_interval:optional
#  archive_date:optional

# If the caller specified a URL, then we gather the package_id from that URL
if { [info exists url] } {
    array set blog_site_node [site_node $url]
    set package_id $blog_site_node(object_id)
}

# If they supplied neither url nor package_id, then we just use ad_conn package_id
if { ![info exists package_id] } {
    set package_id [ad_conn package_id]
}

if { ![info exists type] } {
    set type "current"
}

switch -exact $type {
    archive {
        set date_clause "[db_map date_clause_archive]"
    }
    default {
        set date_clause "[db_map date_clause_default]"
    }
}

set show_poster_p [ad_parameter "ShowPosterP" "" "1"]

set package_url [lars_package_url_from_package_id $package_id]

set admin_p [ad_permission_p $package_id admin]

set old_date ""

set count 0

db_multirow blog blog { *SQL* } {
    if { ![string equal $old_date $entry_date_pretty] } {
        set new_date_p "t"
        set old_date $entry_date_pretty
    }
    set row_number [incr count]

    set return_url "${package_url}one-entry?[export_vars { entry_id }]"
    set edit_url "${package_url}admin/entry-edit?[export_vars { entry_id return_url }]"
    set delete_url "${package_url}admin/entry-delete?[export_vars { entry_id return_url }]"
    set publish_url "${package_url}admin/entry-publish?[export_vars { entry_id return_url }]"
    set revoke_url "${package_url}admin/entry-revoke?[export_vars { entry_id return_url }]"
    set entry_archive_url "${package_url}one-entry?[export_vars { entry_id }]"

    set comment_add_url "[general_comments_package_url]comment-add?[export_vars { { object_id $entry_id } { object_name {[ad_html_to_text -- $title]} } { return_url "${package_url}flush-cache?[export_vars { return_url }]"} }]"
    set comments_view_url "${package_url}one-entry?[export_vars { entry_id }]"
    
    set google_url "http://www.google.com/search?[export_vars { {q $title } }]"

    set content [ns_adp_parse -string $content]
}

set archive_url "${package_url}archive/"
set arrow_url "${package_url}graphics/arrow-box.gif"

set entry_add_url "${package_url}admin/entry-edit"

ad_return_template 
