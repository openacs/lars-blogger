ad_page_contract {
    The Weblogger index page.

    @author Lars Pind (lars@pinds.com)
    @creation-date February 2002
} {
    {screen_name:optional {}}
    {category_short_name:optional {}}
    {sw_category_id:naturalnum,optional {}}
    year:optional,string_length_range(4|4)
    month:optional,string_length_range(2|2)
    day:optional,string_length_range(2|2)
}

set page_title [lars_blog_name]

set package_id [ad_conn package_id]

set package_url [ad_conn package_url]
set package_url_with_extras $package_url

set index_page_p 1
set show_archive_p [parameter::get -parameter "ShowArchiveP"]

set context [list]
set context_base_url $package_url

if { $screen_name ne "" } {
    # Show Screen Name in context bar
    append context_base_url /user/$screen_name
    lappend context [list $context_base_url $screen_name]

    append package_url_with_extras user/$screen_name/
}

if { $category_short_name ne "" } {
    if { ![db_0or1row get_category_from_short_name {}] } {
	ad_return_error "[_ lars-blogger.lt_Category_doesnt_exist]" "[_ lars-blogger.lt_The_specified_categor]"
	return
    }
    # Show Category in context bar
    append context_base_url /category/$category_short_name
    lappend context [list $context_base_url $category_name]
    
    set index_page_p 0
} else {
    set category_id ""
}

# Set up the <link> elements for the HTML <head>
# 3 items - RSS, RSD and stylesheet.
set rss_file_url [parameter::get -parameter rss_file_url -default ""]
if { $rss_file_url eq "" && [parameter::get -parameter "rss_file_name"] ne "" } {
    if {([info exists screen_name] && $screen_name ne "")} {
        set rss_file_url "${package_url}user/$screen_name/rss/[parameter::get -parameter "rss_file_name"]"
    } else {
        set rss_file_url "${package_url}rss/[parameter::get -parameter "rss_file_name"]"
    }
}

# is XML-RPC installed and enabled?
set rsd_url ""
if { [xmlrpc::enabled_p] } {
    set rsd_url "[ad_url]${package_url}rsd/"
}

set stylesheet_url [lars_blog_stylesheet_url]

set unpublish_p [expr {![parameter::get -parameter ImmediatePublishP -default 0]}] 

# We say manageown if manageown set and not admin on the package.
set manageown_p [parameter::get -parameter OnlyManageOwnPostsP -default 0]
if {$manageown_p} {
    set manageown_p [expr {![permission::permission_p -object_id $package_id -privilege admin]}] 
}

# header stuffs
if { $rss_file_url ne ""} {
    template::head::add_link -rel "alternate" -href $rss_file_url -type "application/rss+xml"
}
if { $rsd_url ne ""} {
    template::head::add_link -rel "EditURI" -href $rsd_url -type "application/rsd+xml" -title "RSD"
}

template::head::add_css -href $stylesheet_url

set create_p [permission::permission_p -object_id $package_id -privilege create -party_id [ad_conn untrusted_user_id]]
set admin_p [permission::permission_p -object_id $package_id -privilege admin -party_id [ad_conn untrusted_user_id]]

set display_users_p [parameter::get -parameter "DisplayUsersP" -default 0]
set display_categories [lars_blog_categories_p -package_id $package_id]

if {$display_users_p && (![info exists screen_name] || $screen_name eq "")} {

    set display_bloggers_p 1

    db_multirow bloggers bloggers {}

    set user_has_blog_p 0
    multirow foreach bloggers {
        if { $user_id == [ad_conn user_id] } {
            set user_has_blog_p 1
            break
        }
    }

    ad_return_template

} else {

    set display_bloggers_p 0

}

set notification_chunk [notification::display::request_widget \
    -type lars_blogger_notif \
    -object_id $package_id \
    -pretty_name [lars_blog_name] \
    -url [lars_blog_public_package_url] \
]

set header_background_color [lars_blog_header_background_color]

if { ([info exists year] && $year ne "") } {
    
    set index_page_p 0

    # Show Year and Month in context
    append context_base_url archive/
    lappend context [list $context_base_url Archive]

    append context_base_url $year
    lappend context [list $context_base_url $year]

    if { ([info exists day] && $day ne "") } {
        if {[db_type] eq "oracle"} {
          # Oracle does have format called 'day' but it means
          # something else...
          set interval "ddd"
        } {
          set interval "day"
        }
        db_1row archive_date_month_day {}

	# Month and day in context
        append context_base_url /$month
        lappend context [list $context_base_url [lc_time_fmt "1970-$month-01 01:01:01" %B]]
	append context_base_url /$day
	lappend context [list $context_base_url $day]

    } elseif { ([info exists month] && $month ne "") } {
        set interval "month"
        db_1row archive_date_month {}

        # Month in context
        append context_base_url /$month
        lappend context [list $context_base_url [lc_time_fmt "1970-$month-01 01:01:01" %B]]
    } else {
        set interval "year"
        db_1row archive_date_year {}
    }

    append page_title "[_ lars-blogger.Archive]"
    set date "$year-[ad_decode $month "" "01" $month]-[ad_decode $day "" "01" $day]"
    set type "archive"

} else {
    set date ""
    set type "current"
    set interval ""
    set archive_date ""
}

db_multirow categories categories {}

# Site-Wide Categories

if { $sw_category_id ne "" } {
    set sw_category_name [category::get_name $sw_category_id]
    if { $sw_category_name eq "" } {
        ad_return_exception_page 404 "No such category" "Site-wide \
          Category with ID $sw_category_id doesn't exist"
	    return
    }
    # Show Category in context bar
    append context_base_url /swcat/$sw_category_id
    lappend context [list $context_base_url $sw_category_name]
    set type "all"
}

set counts {}
set sw_cats 0
db_foreach catcount {select c.category_id as catid, count(*) as count from category_object_map c, pinds_blog_entries e where e.package_id = :package_id and c.object_id = e.entry_id group by c.category_id} { 
    lappend counts $catid $count
    if {$count > 0} {
        incr sw_cats
    }
}

if {$sw_cats} {
    db_multirow -unclobber -extend { sw_category_name tree_name } sw_categories sw_categories {
        select c.category_id as sw_category_id, c.tree_id
        from   categories c, category_tree_map ctm
        where  ctm.tree_id = c.tree_id
        and    ctm.object_id = :package_id
    } {
        set sw_category_name [category::get_name $sw_category_id]
        set tree_name [category_tree::get_name $tree_id]
    }

    set container_id [ad_conn [parameter::get -parameter CategoryContainer -default package_id]]
    category_tree::get_multirow -datasource sw_categories -container_id $container_id -category_counts $counts
}

# Cut the URL off the last item in the context bar
if { [llength $context] > 0 } {
    set context [lreplace $context end end [lindex $context end end]]
}

set blog_name [lars_blog_name]
