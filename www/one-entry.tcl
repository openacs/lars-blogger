ad_page_element_contract {} {
    entry_id:integer
    {return_url {[ad_return_url]}}
}

lars_blogger::entry::get -entry_id $entry_id -array blog

set package_id $blog(package_id)

# SWC

set sw_category_multirow "__branimir__multirow__blog/$entry_id"

template::multirow create $sw_category_multirow sw_category_id \
  sw_category_name sw_category_url

set package_url [lars_blog_public_package_url -package_id $package_id]

foreach sw_category_id [category::get_mapped_categories $entry_id] {
  set sw_category_url ""
  if { $sw_category_id != "" } {
      set sw_category_url "${package_url}"
      if { [exists_and_not_null screen_name] } {
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

if {![exists_and_not_null screen_name]} {
    set screen_name ""
    set context [list $page_title]
} else {
    set context [list $screen_name]
}

set stylesheet_url [lars_blog_stylesheet_url -package_id $package_id]

