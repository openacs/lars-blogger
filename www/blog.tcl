# no ad_page_contract because this is intended to be included in other files
#    package_id:integer,optional
#    url:optional
#    {type "current"}  (allowed values: current archive)
#    {archive_interval ""}
#    {archive_date ""}

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
        set date_clause "[db_map date_clause_archive_$archive_interval]"
    }
    default {
        set date_clause "[db_map date_clause_default]"
    }
}

set show_poster_p [parameter::get -package_id $package_id -parameter "ShowPosterP" -default "1"]

set package_url [lars_blog_public_package_url -package_id $package_id]

set blog_name [lars_blog_name -package_id $package_id]

if { [ad_conn isconnected] && ![string equal $package_url [string range [ad_conn url] 0 [string length $package_url]]] } {
    set blog_url $package_url
} else {
    set blog_url {}
}

set admin_p [ad_permission_p $package_id admin]

set num_entries [db_string num_entries {}]

if { $num_entries < 3 } {
    set date_clause {1=1}
    set limit_clause [db_map limit_clause]
} else {
    set limit_clause {}
}

db_multirow blog blog {} 

set archive_url "${package_url}archive/"
set arrow_url "${package_url}graphics/arrow-box.gif"

set entry_add_url "${package_url}admin/entry-edit"

set header_background_color [lars_blog_header_background_color -package_id $package_id]

if { [catch {
    set notification_chunk [notification::display::request_widget \
                                -type lars_blogger_notif \
                                -object_id [ad_conn package_id] \
                                -pretty_name [lars_blog_name] \
                                -url [lars_blog_public_package_url]]
}] } {
    set notification_chunk {}
}
