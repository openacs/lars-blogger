ad_page_contract {} {
    {entry_id:integer ""}
    {return_url ""}
    {title:allhtml ""}
    {title_url ""}
    {content:allhtml ""}
}

# Must be logged in
auth::require_login

# Must have create on the package
permission::require_permission -object_id [ad_conn package_id] -privilege create

# If we're in DisplayUserP mode, the user must have a screen name setup
if { [parameter::get -parameter "DisplayUsersP" -default 0] } {
    acs_user::get -user_id [ad_conn user_id] -array user_info
    if { [empty_string_p $user_info(screen_name)] } {

        set page_title "Screen Name"
        set context [list $page_title]
        set pvt_home_url [ad_pvt_home]
        set pvt_home_name [ad_pvt_home_name]

        ad_return_template screen-name-setup
        return
    }
}


set package_id [ad_conn package_id]
set now_ansi [clock format [clock seconds] -format "%Y-%m-%d %H:%M:%S"]

form create entry -cancel_url [ad_decode $return_url "" "." $return_url]

element create entry title -label "Title" -datatype text -html { size 50 }
element create entry title_url -label "Title URL" -datatype text -html { size 50 } -optional

# If categories are enabled, set up a select-box with option. 
if { [string equal [lars_blog_categories_p] "1"] } {
    set options_list [db_list_of_lists categories {}]
    if { [llength $options_list] > 0 } {
        set option_list [concat [list [list None ""]] $options_list]
        element create entry category_id -label "Category" -datatype integer -widget select -options $option_list -optional
    } else {
        element create entry category_id -datatype integer -widget hidden -value {} -optional
    }
}

element create entry content -label "Content" -datatype richtext -widget richtext -html { cols 80 rows 20 }

element create entry entry_date -label "Entry date" -datatype text \
    -help_text "Format: YYYY-MM-DD HH24:MI:SS" \
    -html { size 20 } \
    -after_html {(<a href="javascript:setEntryDateToToday()">Set to now</a>)}

element create entry draft_p -label "Post Status" -datatype text -widget select -options { { "Draft" "t" } { "Publish" "f" } }

element create entry entry_id -widget hidden -datatype text
element create entry insert_or_update -widget hidden -datatype text
element create entry return_url -widget hidden -datatype text -value $return_url

if { [form is_request entry] } {

    if { [empty_string_p $entry_id] } {
        set insert_or_update insert
        set entry_id [db_nextval "acs_object_id_seq"]
        element set_properties entry entry_date -value $now_ansi
        element set_properties entry draft_p -value "t"

        # Prefill title and content with supplied values
        foreach element { title title_url } {
            if { [exists_and_not_null $element] } {
                element set_value entry $element [set $element]
            }
        }
	if { [exists_and_not_null content] } {
	    element set_value entry content [template::util::richtext::create $content]
	}
    } else {
        set insert_or_update update
        
        permission::require_write_permission -object_id $entry_id

        db_1row entry {}
        
        element set_value entry title $title
        element set_value entry title_url $title_url

        set content_data [template::util::richtext::acquire contents $content]
        set content_data [template::util::richtext::set_property format $content_data $content_format]

        element set_value entry category_id $category_id
        element set_value entry content $content_data

        element set_value entry entry_date $entry_date
        element set_value entry draft_p $draft_p
    }

    element set_properties entry entry_id -value $entry_id
    element set_properties entry insert_or_update -value $insert_or_update
}


if { [form is_valid entry] } {
    set entry_id [element get_value entry entry_id]
    set title [element get_value entry title]
    set title_url [element get_value entry title_url]
    set category_id [element get_value entry category_id]
    set content [template::util::richtext::get_property contents [element get_value entry content]]
    set content_format [template::util::richtext::get_property format [element get_value entry content]]
    set entry_date [element get_value entry entry_date]
    set draft_p [element get_value entry draft_p]
    set draft_p [ad_decode $draft_p "" "f" $draft_p]

    set return_url [element get_value entry return_url]
    set insert_or_update [element get_value entry insert_or_update]

    if { [string equal $insert_or_update "insert"] } {
        lars_blogger::entry::new \
	    -entry_id $entry_id \
	    -package_id $package_id \
	    -title $title \
	    -title_url $title_url \
	    -category_id $category_id \
	    -content $content \
	    -content_format $content_format \
	    -entry_date $entry_date \
	    -draft_p "$draft_p"
    } else {
        permission::require_write_permission -object_id $entry_id

        lars_blogger::entry::edit \
            -entry_id $entry_id \
            -title $title \
            -title_url $title_url \
            -category_id $category_id \
            -content $content \
            -content_format $content_format \
            -entry_date $entry_date \
            -draft_p $draft_p
    }
    
    if { [empty_string_p $return_url] } {
        set return_url "one-entry?[export_vars { entry_id }]"
    }

    ad_returnredirect $return_url
    ad_script_abort
} 

if { ![form is_request entry] && ![form is_valid entry] } {
    set insert_or_update [element get_value entry insert_or_update]
}

switch -- $insert_or_update {
    insert {
        set page_title "Add Blog Entry"
    }
    update {
        set page_title "Edit Blog Entry"
    }
}

set context [list $page_title]
