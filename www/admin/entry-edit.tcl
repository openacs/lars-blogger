ad_page_contract {} {
    {entry_id:integer ""}
    {return_url ""}
    {title ""}
    {content:allhtml ""}
} -properties {
    context_bar
    today_html
}

set today [db_string today {}]

form create entry -cancel_url [ad_decode $return_url "" "../" $return_url]

element create entry title -label "Title" -datatype text -html { size 50 }
element create entry content -label "Content" -datatype richtext -widget richtext -html { cols 80 rows 20 }
element create entry entry_date -label "Entry date" -datatype text \
        -help_text "If you set this to something other than today's date, you must use this form to publish your entry, otherwise the entry date will be set to the date you publish the item." \
        -after_html {(<a href="javascript:setEntryDateToToday()">Set to today</a>)}

element create entry draft_p -label "Post Status" -datatype text -widget select -options { { "Draft" "t" } { "Publish" "f" } }

element create entry entry_id -widget hidden -datatype text
element create entry return_url -widget hidden -datatype text -value $return_url

if { [form is_request entry] } {

    if { [empty_string_p $entry_id] } {
        set entry_id [db_nextval "acs_object_id_seq"]
        element set_properties entry entry_date -value $today
        element set_properties entry draft_p -value "t"

        # Prefill title and content with supplied values
        if { [exists_and_not_null title] } {
            element set_value entry title $title
        }
        if { [exists_and_not_null content] } {
            element set_value entry content [template::util::richtext::acquire contents $content]
        }

    } else {
        db_1row entry {}
        
        element set_value entry content \
                [template::util::richtext::set_property format [template::util::richtext::acquire contents $content] $content_format]
        
        element set_value entry title $title
        element set_value entry entry_date $entry_date
        element set_value entry draft_p $draft_p
    }

    element set_properties entry entry_id -value $entry_id
}


if { [form is_valid entry] } {
    set entry_id [element get_value entry entry_id]
    set title [element get_value entry title]
    set content [template::util::richtext::get_property contents [element get_value entry content]]
    set content_format [template::util::richtext::get_property format [element get_value entry content]]
    set entry_date [element get_value entry entry_date]
    set draft_p [element get_value entry draft_p]
    set draft_p [ad_decode $draft_p "" "f" $draft_p]

    set return_url [element get_value entry return_url]
    

    if { [db_string entry_exists {}] == 0 } {
        lars_blog_entry_add \
                -entry_id $entry_id \
                -package_id [ad_conn package_id] \
                -title $title \
                -content $content \
                -content_format $content_format \
                -entry_date $entry_date \
                -draft_p "$draft_p"
    } else {
        set set_clauses { 
            "title = :title" 
            "content = :content"
            "content_format = :content_format"
            "entry_date = to_date(:entry_date, 'YYYY-MM-DD')" 
            "draft_p = :draft_p" 
        }

        set org_draft_p [db_string org_draft_p {}]

        if { [string equal $draft_p "t"] && [string equal $org_draft_p "f"] } {
            # If this is a publish, set the posted_date to now
            lappend set_clauses [db_map now]
        }
    
        db_dml update_entry {}

        lars_blog_flush_cache [ad_conn package_id]
    }
    
    if { [empty_string_p $return_url] } {
        set return_url "[ad_conn package_url]one-entry?[export_vars { entry_id }]"
    }

    ad_returnredirect $return_url
    ad_script_abort
} 

set page_title "Blog Entry"

set context_bar [ad_context_bar $page_title]

ad_return_template
