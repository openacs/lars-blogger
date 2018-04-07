# Expects:
#  package_id:optional
#  url:optional
#  type:optional (current, archive, all)
#  sw_category_id:optional
#  archive_interval:optional
#  archive_date:optional
#  screen_name:optional
#  max_num_entries: optional
#  min_num_entries: optional
#  num_days: optional
#  max_content_length:integer,optional
#  create_p:boolean
#  display_template:
#  unpublish_p
#  manageown_p

# If the caller specified a URL, then we gather the package_id from that URL
if { [info exists url] } {
    array set blog_site_node [site_node::get -url $url]
    set package_id $blog_site_node(object_id)
}

# If they supplied neither url nor package_id, then we just use ad_conn package_id
if { ![info exists package_id] } {
    set package_id [ad_conn package_id]
}

if {! [info exists create_p] } { 
    set create_p [permission::permission_p -object_id $package_id -privilege create]
}

if {(![info exists unpublish_p] || $unpublish_p eq "")} { 
    set unpublish_p 1
}
if {(![info exists manageown_p] || $manageown_p eq "")} { 
    set manageown_p [expr {![permission::permission_p -object_id $package_id -privilege admin]}] 
}


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
    unset sw_category_id
}

if { ![info exists screen_name] } {
    set screen_name ""
    set blog_user_id {}
} else {
    set blog_user_id [acs_user::get_user_id_by_screen_name -screen_name  $screen_name]
}

if { ![info exists max_num_entries] || $max_num_entries eq "" } {
    set max_num_entries [parameter::get \
                             -package_id $package_id \
                             -parameter MaxNumEntriesOnFrontPage \
                             -default {}]
}

if { ![info exists min_num_entries] || $min_num_entries eq "" } {
    set min_num_entries [parameter::get \
                             -package_id $package_id \
                             -parameter MinNumEntriesOnFrontPage \
                             -default {}]
}

if { ![info exists num_days] || $num_days eq "" } {
    set num_days [parameter::get \
                      -package_id $package_id \
                      -parameter NumDaysOnFrontPage \
                      -default {}]
}

if { ![info exists max_content_length] || $max_content_length eq "" } {
    set max_content_length [parameter::get \
                                -package_id $package_id \
                                -parameter max_content_length \
                                -default 0]
}


if { ![info exists type] } {
    set type "current"
}

if { ![info exists entry_chunk] } {
    set entry_chunk "entry-chunk"
}

switch -exact $type {
    archive {
        set date_clause [db_map date_clause_archive]
        set limit {}
    }
    current {
        set date_clause {}
        set limit {}

        if { $max_num_entries ne "" && $max_num_entries != 0 } {
            # MaxNumEntriesOnFrontPage parameter is set, which means we should limit to that
            set limit $max_num_entries
        } 

        if { $num_days ne "" && $num_days != 0 } {
            # NumDaysOnFrontPage parameter is set, which means we should limit to that
            set date_clause [db_map date_clause_default]
        }
    }
    all {
        set date_clause {}
        set limit {}
    }
    default {
        error "Only knows of type 'archive', 'current', and 'all'."
    }
}

set show_poster_p [parameter::get -parameter "ShowPosterP" -default "1"]

set package_url [lars_blog_public_package_url -package_id $package_id]

set blog_name [lars_blog_name -package_id $package_id]

if { [ad_conn isconnected] && ![string equal $package_url [string range [ad_conn url] 0 [string length $package_url]]] } {
    set blog_url $package_url
} else {
    set blog_url {}
}

# Check that the date limit is not limiting us to show less than min_num_entries entries
if { $type ne "archive" && 
     $min_num_entries ne "" && $min_num_entries != 0 && 
     $num_days ne "" && $num_days != 0 
 } {
    if { $blog_user_id eq "" } {
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

if { $blog_user_id eq "" } {
    set user_filter_where_clause ""
    set archive_url "${package_url}archive/"
} else {
    set user_filter_where_clause [db_map user_filter_where_clause]
    set archive_url "${package_url}user/$screen_name/archive/"
}

# SWC

# In case we are filtering by blog_sw_category_id we will need to join
# against category_object_map twice: once to restrict to the one
# category and second time to get other categories this item is in.

if { [string length $blog_sw_category_id] } {
    set sw_category_filter_where_clause [db_map sw_category_filter_where_clause]
    set sw_category_filter_join_clause [db_map sw_category_filter_join_clause]
    # This is the thing that doesn't exist in PostgreSQL:
    set sw_category_filter_join_where_clause [db_map sw_category_filter_join_where_clause]
} else {
    set sw_category_filter_where_clause ""
    set sw_category_filter_join_clause ""
    set sw_category_filter_join_where_clause ""
}

# Our query will have more than one row per item_id.  This variable
# keeps count of the actual rows that get inserted in the multirow.

set output_rows_count 0

db_multirow -extend {
    category_name category_short_name sw_category_multirow permalink_url
} blog blog {} {

    # Putting the limit in the query won't give correct results.  We
    # need to do it here:

    if {$limit ne ""} {
      if {$output_rows_count >= $limit} {break}
    }

    # Filtering by old blog-specific categories is still done here.
    # This code will be removed eventually

    if { [string length $blog_category_id] && \
      $category_id != $blog_category_id} {continue}

    set sw_category_url ""
    if { $sw_category_id ne "" } {
        set sw_category_url "${package_url}"
        if { ([info exists screen_name] && $screen_name ne "") } {
    	  append sw_category_url "user/$screen_name"
        }
        append sw_category_url "swcat/$sw_category_id"
    }

    set permalink_url [export_vars -base ${package_url}one-entry { entry_id }]

    # Inner multirow.  Here's its magic name:
    set sw_category_multirow "__branimir__multirow__blog/$entry_id"

    if {![template::multirow exists $sw_category_multirow]} {
      # This is the first row in this group so create the inner multirow
      template::multirow create $sw_category_multirow sw_category_id \
        sw_category_name sw_category_url
    }

    # Add a row to the inner multirow:
    template::multirow append $sw_category_multirow $sw_category_id \
      [category::get_name $sw_category_id] $sw_category_url

    if {[db_multirow_group_last_row_p -column entry_id]} {
      incr output_rows_count
    } {
      # This is not the last multirow in the group.  Skip creating rows
      # in the main multirow:
      continue
    }

    set category_name "$arr_category_name($category_id)"
    set category_short_name $arr_category_short_name($category_id)
}

set arrow_url "${package_url}graphics/arrow-box.gif"

set entry_add_url "${package_url}entry-edit"

set header_background_color [lars_blog_header_background_color -package_id $package_id]

set stylesheet_url [lars_blog_stylesheet_url -package_id $package_id]

set rss_file_url [lars_blogger::get_rss_file_url -package_id $package_id]

template::head::add_css -href $stylesheet_url

if { ([info exists display_template] && $display_template ne "") } {
    ad_return_template $display_template
}
