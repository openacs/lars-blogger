ad_page_contract {} {
    entry_id:naturalnum,notnull
    {return_url {[ad_return_url]}}
}

set package_id [ad_conn package_id]

set show_poster_p [parameter::get -parameter "ShowPosterP" -default "1"]

if {[catch {lars_blogger::entry::get -entry_id $entry_id -array blog} errMsg]} {
    if {$::errorCode eq "NOT_FOUND"} {
        ns_returnnotfound
        ad_script_abort
    }
    error $errMsg $::errorInfo $::errorCode
}

# SWC

set sw_category_multirow "__branimir__multirow__blog/$entry_id"

set unpublish_p [expr {![parameter::get -parameter ImmediatePublishP -default 0]}] 

# We say manageown if manageown set and not admin on the package.
set manageown_p [parameter::get -parameter OnlyManageOwnPostsP -default 0]
if {$manageown_p} {
    set manageown_p [expr {![permission::permission_p -object_id $package_id -privilege admin]}] 
}

template::multirow create $sw_category_multirow sw_category_id \
  sw_category_name sw_category_url

set package_url [lars_blog_public_package_url -package_id $package_id]

foreach sw_category_id [category::get_mapped_categories $entry_id] {
  set sw_category_url ""
  if { $sw_category_id ne "" } {
      set sw_category_url "${package_url}"
      if { ([info exists screen_name] && $screen_name ne "") } {
  	  append sw_category_url "user/$screen_name"
      }
      append sw_category_url "swcat/$sw_category_id"
  }

  # Add a row to the inner multirow:
  template::multirow append $sw_category_multirow $sw_category_id \
    [category::get_name $sw_category_id] $sw_category_url
}

# Put name of multirow where entry-chunk.tcl will be able to find it:

set blog(sw_category_multirow) $sw_category_multirow

if { [template::util::is_true $blog(draft_p)] } {
    permission::require_write_permission -object_id $entry_id -creation_user $blog(user_id) -action "view"
}

set page_title $blog(title)

if {![info exists screen_name] || $screen_name eq ""} {
    set screen_name ""
    set context [list $page_title]
    set blog(permalink_url) [export_vars -base ${package_url}one-entry { entry_id }]
} else {
    set blog(permalink_url) [export_vars -base ${package_url}user/$screen_name/one-entry { entry_id }]
    set context [list $screen_name]
}

set header_background_color [lars_blog_header_background_color]

template::head::add_css -href [lars_blog_stylesheet_url]
