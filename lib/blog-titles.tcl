# packages/lars-blogger/lib/blog-titles.tcl
#
# Include to show the titles of a blog entry
#
# @author sussdorff aolserver (sussdorff@ipxserver.de)
# @creation-date 2005-02-21
# @arch-tag: d69f0030-e717-41db-9816-c53d5abf4067
# @cvs-id $Id$

# Expects:
#  package_id:optional
#  url:optional
#  max_num_entries: optional
#  num_days: optional

# If the caller specified a URL, then we gather the package_id from that URL
if { [info exists url] } {
    array set site_node_array [site_node::get -url $url]
    set package_id $site_node_array(package_id)
}

# If they supplied neither url nor package_id, then we just use ad_conn package_id
if { ![info exists package_id] } {
    set package_id [ad_conn package_id]
}

set package_url [lars_blog_public_package_url -package_id $package_id]

set blog_name [lars_blog_name -package_id $package_id]

if { [ad_conn isconnected] && ![string equal $package_url [string range [ad_conn url] 0 [string length $package_url]]] } {
    set blog_url $package_url
} else {
    set blog_url {}
}

if { [exists_and_not_null max_num_entries] } {
    # MaxNumEntriesOnFrontPage parameter is set, which means we should limit to that
    set limit $max_num_entries
} else {
    set limit ""
}

if { [exists_and_not_null num_days] } {
    # NumDaysOnFrontPage parameter is set, which means we should limit to that
    set date_clause [db_map date_clause_default]
} else {
    set date_clause ""
}

set output_rows_count 0

db_multirow -extend {permalink_url} titles blog-titles "" {

    if {$limit != ""} {
	if {$output_rows_count >= $limit} {break}
    }

    incr output_rows_count
    set permalink_url "${package_url}one-entry?[export_vars { entry_id }]"
}

set arrow_url "${package_url}graphics/arrow-box.gif"
