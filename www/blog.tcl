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

set create_p [permission::permission_p -object_id $package_id -privilege read]

if { ![info exists category_id] } {
    set blog_category_id {}
} else {
    set blog_category_id $category_id
}

# SWC
if { ![info exists sw_category_id] } {
    set blog_sw_category_id {}
} else {
    set blog_sw_category_id $sw_category_id
}

if { ![info exists screen_name] } {
    set screen_name ""
    set blog_user_id {}
} else {
    set blog_user_id [cc_screen_name_user $screen_name]
}

set max_num_entries [parameter::get \
                       -package_id $package_id \
                       -parameter MaxNumEntriesOnFrontPage \
                       -default {}]

set min_num_entries [parameter::get \
                         -package_id $package_id \
                         -parameter MinNumEntriesOnFrontPage \
                         -default {}]

set num_days [parameter::get \
                  -package_id $package_id \
                  -parameter NumDaysOnFrontPage \
                  -default {}]
        
        

if { ![info exists type] } {
    set type "current"
}

switch -exact $type {
    archive {
        set date_clause [db_map date_clause_archive]
        set limit {}
    }
    current {
        set date_clause {}
        set limit {}

        if { ![empty_string_p $max_num_entries] && $max_num_entries != 0 } {
            # MaxNumEntriesOnFrontPage parameter is set, which means we should limit to that
            set limit $max_num_entries
        } 

        if { ![empty_string_p $num_days] && $num_days != 0 } {
            # NumDaysOnFrontPage parameter is set, which means we should limit to that
            set date_clause [db_map date_clause_default]
        }
    }
    default {
        error "Only knows of type 'archive' or 'current'"
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

# Check that the date limit is not limiting us to show less than min_num_entries entries
if { ![string equal $type "archive"] && \
         ![empty_string_p $min_num_entries] && $min_num_entries != 0 && \
         ![empty_string_p $num_days] && $num_days != 0 
 } {
    if { [empty_string_p $blog_user_id] } {
        set num_entries [db_string num_entries_by_date_all {}]
    } else {
        set num_entries [db_string num_entries_by_date {}]
    }
    
    if { $num_entries < $min_num_entries } {
       # Eliminate date clause, and set the limit to the minimum number of entries
       set date_clause {}
       set limit $min_num_entries
   }  
}

set arr_category_name() None
set arr_category_short_name() none
db_foreach categories {} {
    set arr_category_name($category_id) $name
    set arr_category_short_name($category_id) $short_name
}

if { [empty_string_p $blog_user_id] } {
    set blog_query_name all_blogs
    set archive_url "${package_url}archive/"
} else {
    set blog_query_name blog
    set archive_url "${package_url}user/$screen_name/archive/"
}


db_multirow -extend {category_name category_short_name } \
      blog $blog_query_name {} {
    if { [string length $blog_category_id] && \
      $category_id != $blog_category_id} {continue}

    set category_name "$arr_category_name($category_id)"
    set category_short_name $arr_category_short_name($category_id)
}

set arrow_url "${package_url}graphics/arrow-box.gif"

set entry_add_url "${package_url}entry-edit"

set header_background_color [lars_blog_header_background_color -package_id $package_id]

set stylesheet_url [lars_blog_stylesheet_url]

