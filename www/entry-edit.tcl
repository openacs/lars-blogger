# As we are using the formbuilder return_url, title, title_url and
# content are not necessary in ad_page_contract.  However Lars says it
# is convenient to have them here so people can create custom bookmarks
# to this page that prefill these values:

ad_page_contract {} {
    {entry_id:integer,optional}
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
    set page_title "Add Blog Entry"
} else {
    set page_title "Edit Blog Entry"
}

set valid_url_example "http://www.example.com/foo"

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

ad_form -name entry \
    -cancel_url [ad_decode $return_url "" "." $return_url] \
    -form {entry_id:key(acs_object_id_seq)
        {title:text
            {label Title}
            {html {size 50}}}
        {title_url:text,optional
            {label "Title URL"}
            {help_text "If this entry is a rant on a web page you can \
                put the full URL here, e.g. $valid_url_example"}
            {html {size 50}}
        }
    } \
    -export {return_url}

# If categories are enabled, set up a select-box with option. 

if { [string equal [lars_blog_categories_p] "1"] } {
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

ad_form -extend -name entry -form {
    {content:richtext(richtext)
        {html {cols 80 rows 20}}
        {label "Content"}
    }
}

ad_form -extend -name entry -form {
    {entry_date:text
        {label "Entry date"}
        {help_text "Format: YYYY-MM-DD HH24:MI:SS"}
        {html {size 20}}
        {after_html
            {(<a href="javascript:setEntryDateToToday()">Set to now</a>)}
        }
    }
    {draft_p:text(select)
        {options {{"Draft" "t"} {"Publish" "f"}}}
        {label "Post Status"}
    }
} \
    -new_request {
        set entry_date $now_ansi
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
    } \
    -after_submit {
        ad_returnredirect $return_url
        ad_script_abort
    } \
    -validate {{
        title_url
        {[
            expr {[empty_string_p $title_url] || \
                [util_url_valid_p $title_url]
            }
        ]}
        "Your input \"$title_url\" doesn't look like a valid URL. \
            Example of a valid URL: $valid_url_example"
    }}

set context [list $page_title]
