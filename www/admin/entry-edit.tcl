ad_page_contract {} {
    {entry_id:integer ""}
    {return_url ""}
    cancel:optional
} -properties {
    context_bar
    today_html
}

if { [info exists cancel] } {
    catch { set return_url [element get_value entry return_url] }
    if { [empty_string_p $return_url] } {
        set return_url "."
    }
    ad_returnredirect $return_url
    ad_script_abort
}

set today [db_string today { *SQL* }]
set today_html [ad_quotehtml $today]

form create entry

element create entry title -label "Title" -datatype text -html { size 50 }
element create entry content -label "Content" -datatype text -widget textarea -html { cols 80 rows 20 }
element create entry entry_date -label "Entry date" -datatype text
element create entry entry_date_today -label "Set to today" -datatype text -widget inform -value {(<a href="javascript:setEntryDateToToday()">Set to today</a>)}
element create entry draft_p -label "Draft" -datatype text -widget checkbox -options { { "This is a draft, don't publish it" "t" } } -optional

element create entry entry_id -widget hidden -datatype text
element create entry insert_or_update -widget hidden -datatype text
element create entry return_url -widget hidden -datatype text -value $return_url

if { [form is_request entry] } {

    if { [empty_string_p $entry_id] } {
        set insert_or_update insert
        set entry_id [db_nextval "acs_object_id_seq"]
        element set_properties entry entry_date -value $today
        element set_properties entry draft_p -value "t"
    } else {
        set insert_or_update update
        
        db_1row entry { *SQL* }
        
        element set_properties entry title -value $title
        element set_properties entry content -value $content
        element set_properties entry entry_date -value $entry_date
        element set_properties entry draft_p -value $draft_p
    }

    element set_properties entry entry_id -value $entry_id
    element set_properties entry insert_or_update -value $insert_or_update
}


if { [form is_valid entry] } {
    set entry_id [element get_value entry entry_id]
    set title [element get_value entry title]
    set content [element get_value entry content]
    set entry_date [element get_value entry entry_date]
    set draft_p [element get_value entry draft_p]
    set draft_p [ad_decode $draft_p "" "f" $draft_p]

    set return_url [element get_value entry return_url]
    set insert_or_update [element get_value entry insert_or_update]

    if { [string equal $insert_or_update "insert"] } {
        lars_blog_entry_add \
                -entry_id $entry_id \
                -package_id [ad_conn package_id] \
                -title $title \
                -content $content \
                -entry_date $entry_date \
                -draft_p "$draft_p"
    } else {
        set set_clauses { "title = :title" "content = :content" "entry_date = to_date(:entry_date, 'YYYY-MM-DD')" "draft_p = :draft_p" }

        set org_draft_p [db_string org_draft_p { select draft_p from pinds_blog_entries where entry_id = :entry_id } ]

        if { [string equal $draft_p "t"] && [string equal $org_draft_p "f"] } {
            # If this is a publish, set the posted_date to now
            lappend set_clauses [db_map now]
        }
    
        db_dml update_entry { *SQL* }

        lars_blog_flush_cache [ad_conn package_id]
    }
    
    if { [empty_string_p $return_url] } {
        set return_url "entry-preview?[export_vars { entry_id }]"
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

set context_bar [ad_context_bar $page_title]

ad_return_template