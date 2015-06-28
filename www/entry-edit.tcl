# As we are using the formbuilder return_url, title, title_url and
# content are not necessary in ad_page_contract.  However Lars says it
# is convenient to have them here so people can create custom bookmarks
# to this page that prefill these values:


ad_page_contract {} {
    {entry_id:naturalnum,optional}
    {return_url ""}
    {title:allhtml ""}
    {title_url ""}
    {content:allhtml ""}
}

# Must be logged in
auth::require_login

# Must have create on the package
permission::require_permission -object_id [ad_conn package_id] -privilege create

# This can't go into -edit_request and -new_request blocks b/c we'll
# need it sooner.

if {[ad_form_new_p -key entry_id]} {
    set page_title "[_ lars-blogger.Add_Blog_Entry]"
} else {
    set page_title "[_ lars-blogger.Edit_Blog_Entry]"
}

set valid_url_example "http://www.example.com/foo"

# If we're in DisplayUserP mode, the user must have a screen name setup
if { [parameter::get -parameter "DisplayUsersP" -default 0] } {
    acs_user::get -user_id [ad_conn user_id] -array user_info
    if { $user_info(screen_name) eq "" } {

        set page_title "[_ lars-blogger.Screen_Name]"
        set context [list $page_title]
        set pvt_home_url [ad_pvt_home]
        set pvt_home_name [ad_pvt_home_name]

        ad_return_template screen-name-setup
        return
    }
}


set package_id [ad_conn package_id]
set now_ansi [clock format [clock seconds] -format "%Y-%m-%d %H:%M:%S"]

ad_form -name entry \
    -cancel_url [ad_decode $return_url "" "." $return_url] \
    -form {entry_id:key(acs_object_id_seq)
        {title:text
            {label Title}
            {html {size 50}}}
        {title_url:text,optional
            {label "[_ lars-blogger.Title_URL]"}
            {help_text "[_ lars-blogger.lt_If_this_entry_is_abou]"}
            {html {size 50}}
        }
    } \
    -export {return_url}

# If categories are enabled, set up a select-box with option. 

if {[lars_blog_categories_p] eq "1"} {
    set options_list [db_list_of_lists categories {}]
    if { [llength $options_list] > 0 } {
        set option_list [concat [list [list None ""]] $options_list]
        ad_form -extend -name entry \
            -form {{category_id:integer(select),optional
                    {label Category}
                    {options $options_list}}
            }
    } else {

        ad_form -extend -name entry -form {category_id:integer(hidden),optional}

    }
}
set container_id [ad_conn [parameter::get -parameter CategoryContainer -default package_id]]

# SWC (Site-wide categories):
category::ad_form::add_widgets \
    -container_object_id $container_id \
    -categorized_object_id [value_if_exists entry_id] \
    -form_name entry

ad_form -extend -name entry -form {
    {content:richtext(richtext)
        {html {cols 80 rows 20}}
        {label "[_ lars-blogger.Content]"}
    }
}

ad_form -extend -name entry -form {
    {entry_date:text
        {label "[_ lars-blogger.Entry_date]"}
        {help_text "[_ lars-blogger.lt_Format_YYYY-MM-DD_HH2]"}
        {html {size 20}}
        {after_html
            {(<a href="javascript:setEntryDateToToday()">Set to now</a>)}
        }
    }
}
set unpublish_p [expr {![parameter::get -parameter ImmediatePublishP -default 0]}] 

if {$unpublish_p} {
    ad_form -extend -name entry -form {
        {draft_p:text(select)
            {options {{"[_ lars-blogger.Draft]" "t"} {"[_ lars-blogger.Publish]" "f"}}}
            {label "[_ lars-blogger.Post_Status]"}
        }
    }
} else {
    ad_form -extend -name entry -form {
        {draft_p:text(hidden)}
    }
}

ad_form -extend -name entry \
    -new_request {
        if {$unpublish_p} {
            set draft_p t
        } else {
            set draft_p f
        }
        set entry_date $now_ansi
        set content [template::util::richtext::create $content {}]
    } \
    -edit_request {
        permission::require_write_permission -object_id $entry_id

        lars_blogger::entry::get \
            -entry_id $entry_id \
            -array row
        set title $row(title)
        set title_url $row(title_url)
        set category_id $row(category_id)
        set content [
            template::util::richtext::create \
                $row(content) $row(content_format)
        ]
        set entry_date $row(entry_date_ansi)
        set draft_p $row(draft_p)

    } \
    -on_submit {
        set content_body [
            template::util::richtext::get_property contents $content
        ]
        set content_format [
            template::util::richtext::get_property format $content
        ]
        set entry_date [element get_value entry entry_date]
        set draft_p [element get_value entry draft_p]
        set draft_p [ad_decode $draft_p "" "f" $draft_p]

        # SWC Collect categories from all the category widgets
        set category_ids [category::ad_form::get_categories \
                              -container_object_id $container_id]

    } \
    -new_data {
        lars_blogger::entry::new \
            -entry_id $entry_id \
            -package_id $package_id \
            -title $title \
            -title_url $title_url \
            -category_id $category_id \
            -content $content_body \
            -content_format $content_format \
            -entry_date $entry_date \
            -draft_p "$draft_p"

        # SWC
        category::map_object \
            -remove_old \
            -object_id $entry_id \
            $category_ids

    } \
    -edit_data {
        lars_blogger::entry::edit \
            -entry_id $entry_id \
            -title $title \
            -title_url $title_url \
            -category_id $category_id \
            -content $content_body \
            -content_format $content_format \
            -entry_date $entry_date \
            -draft_p $draft_p

        # SWC
        category::map_object \
            -remove_old \
            -object_id $entry_id \
            $category_ids
    } \
    -after_submit {
        if {"$draft_p" == "t"} {
            ad_returnredirect [export_vars -base one-entry {entry_id}]
        } else {
            ad_returnredirect $return_url
        }
        ad_script_abort
    } \
    -validate {{
        title_url
        {[
            expr {$title_url eq "" || \
                [util_url_valid_p $title_url]
            }
        ]}
        "[_ lars-blogger.lt_Your_input_title_url_]"
    }}

set context [list $page_title]
