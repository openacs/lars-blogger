ad_page_contract {} {
    {entry_id:integer ""}
    {return_url ""}
    {title:allhtml ""}
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
set today [clock format [clock seconds] -format "%Y-%m-%d"]

form create entry -cancel_url [ad_decode $return_url "" "." $return_url]

element create entry title -label "Title" -datatype text -html { size 50 }
element create entry title_url -label "Title URL" -datatype text -html { size 50 } -optional

# If categories are enabled, set up a select-box with option. 
# Otherwise just set the category_id to null to support category support in the future.
if { [string equal [lars_blog_categories_p] "1"] } {
    # It's probably possible to set up the widget directly from the datasource -- I just don't know how :-(
    set option_list [concat [list [list None 0]] [db_list_of_lists categories {}]]
    element create entry category_id -label "Category" -datatype integer -widget select -options $option_list
}

element create entry content -label "Content" -datatype richtext -widget richtext -html { cols 80 rows 20 }
element create entry entry_date -label "Entry date" -datatype text \
        -help_text "If you set this to something other than today's date, you must use this form to publish your entry, otherwise the entry date will be set to the date you publish the item." \
        -after_html {(<a href="javascript:setEntryDateToToday()">Set to today</a>)}

element create entry draft_p -label "Post Status" -datatype text -widget select -options { { "Draft" "t" } { "Publish" "f" } }

element create entry entry_id -widget hidden -datatype text
element create entry insert_or_update -widget hidden -datatype text
element create entry return_url -widget hidden -datatype text -value $return_url

if { [form is_request entry] } {

    if { [empty_string_p $entry_id] } {
        set insert_or_update insert
        set entry_id [db_nextval "acs_object_id_seq"]
        element set_properties entry entry_date -value $today
        element set_properties entry draft_p -value "t"

        # Prefill title and content with supplied values
        foreach element { content title } {
            if { [exists_and_not_null $element] } {
                element set_value entry $element [set $element]
            }
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
        lars_blog_entry_add \
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

        set set_clauses { 
            "title = :title" 
            "title_url = :title_url"
            "category_id = :category_id"
            "content = :content"
            "content_format = :content_format"
            "entry_date = to_date(:entry_date, 'YYYY-MM-DD')" 
            "draft_p = :draft_p" 
        }

        set org_draft_p [db_string org_draft_p { select draft_p from pinds_blog_entries where entry_id = :entry_id } ]

        # Is this a publish?
        if { [string equal $draft_p "t"] && [string equal $org_draft_p "f"] } {
            # set the posted_date to now
            lappend set_clauses [db_map now]
        }
    
        db_dml update_entry { *SQL* }

        # Is this a publish?
        if { [string equal $draft_p "t"] && [string equal $org_draft_p "f"] } {
            # do notifications
            lars_blogger::entry::do_notifications -entry_id $entry_id
            # and ping weblogs.com
            lars_blog_weblogs_com_update_ping
        }
    
        lars_blog_flush_cache $package_id
    }
    
    if { [empty_string_p $return_url] } {
        set return_url "[ad_conn package_url]one-entry?[export_vars { entry_id }]"
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
