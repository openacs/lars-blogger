# Expects:
#  package_id:optional
#  url:optional
#  type:optional (current, archive)
#  archive_interval:optional
#  archive_date:optional
#  screen_name:optional


# If the caller specified a URL, then we gather the package_id from that URL
if { [info exists url] } {
    array set blog_site_node [site_node $url]
    set package_id $blog_site_node(object_id)
}

# If they supplied neither url nor package_id, then we just use ad_conn package_id
if { ![info exists package_id] } {
    set package_id [ad_conn package_id]
}

set write_p [permission::permission_p -object_id $package_id -privilege write]

if { ![info exists screen_name] } {
    set screen_name ""
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

set package_url [lars_blog_public_package_url -package_id $package_id]

set blog_name [lars_blog_name -package_id $package_id]

if { [ad_conn isconnected] && ![string equal $package_url [string range [ad_conn url] 0 [string length $package_url]]] } {
    set blog_url $package_url
} else {
    set blog_url {}
}

set count 0

if { ![exists_and_not_null screen_name] } {
    
    db_multirow blog all_blogs { *SQL* } 
    set archive_url "${package_url}archive/"

} else {

    db_multirow blog blog { *SQL* }
    set archive_url "${package_url}user/$screen_name/archive/"

}

set arrow_url "${package_url}graphics/arrow-box.gif"

set entry_add_url "${package_url}entry-edit"

set header_background_color [lars_blog_header_background_color -package_id $package_id]

ad_return_template 
