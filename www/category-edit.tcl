ad_page_contract {
    View and edit blogger categories.

    @author Steffen Christensen (steffen@refresh.dk)
    @cvs-id $Id$
} {
    category_id:integer,optional
    {return_url ""}
    {name:allhtml ""}
    {short_name:allhtml ""}
}

set page_title "Manage Categories"
set context [list $page_title]

# Must be logged in
auth::require_login

# Must have admin privilege (since categories are package-wide, not just per user)
permission::require_permission -object_id [ad_conn package_id] -privilege admin

set package_id [ad_conn package_id]

if { [lars_blog_categories_p -package_id $package_id] != 1} {
    ad_return_error "[_ lars-blogger._No]" "[_ lars-blogger._Categories]"
    ad_script_abort
}

if { [empty_string_p $return_url] } {
    set return_url [ad_conn url]
}

#####
#
# Add/edit form
#
#####

ad_form -name category -cancel_url $return_url -form {
    {category_id:key}
    {name:text
        {label "[_ lars-blogger.Category]"}
        {html { size 50 }}
    }
    {short_name:text,optional
        {label "[_ lars-blogger._Category_1]"}
        {html { size 20 }}
        {help_text "[_ lars-blogger._This_1]"}
    }
    {return_url:text(hidden),optional}
} -new_request {

} -edit_request {

    db_1row category {}

} -on_submit {
    
    if { ![empty_string_p $short_name] } {
	db_1row short_name_exists { *SQL* }
	if { $short_name_exists > 0 } {
	    form set_error category short_name "[_ lars-blogger._This_2]"
	    break
	}
    }

} -new_data {

    lars_blogger::category::new \
        -name $name \
        -category_id $category_id \
        -short_name $short_name

} -edit_data {

    lars_blogger::category::edit \
        -category_id $category_id \
        -name $name \
        -short_name $short_name

} -after_submit {
    ad_returnredirect $return_url
    ad_script_abort
}



#####
#
# Category list
#
#####

template::list::create \
    -name categories \
    -multirow categories \
    -actions {
        "[_ lars-blogger._Add_4]" "category-edit" "[_ lars-blogger._Add_5]"
    } -elements {
        edit {
            label {}
            display_template {<img src="/resources/acs-subsite/Edit16.gif" width="16" height="16" border="0" alt="[_ lars-blogger.Edit]">}
            link_url_eval {[export_vars -base [ad_conn url] { category_id }]}
            link_html { title "[_ lars-blogger._Edit]" }
            sub_class narrow
        }
        name {
            label {Name}
            link_url_eval {[ad_conn package_url]cat/$short_name/}
        }
        short_name {
            label {Short Name}
        }
        num_entries {
            label {\# Entries}
            html { align right }
            display_col num_entries_pretty
        }
        delete {
            label {}
            display_template {<img src="/resources/acs-subsite/Delete16.gif" width="16" height="16" border="0" alt="[_ lars-blogger.Delete]">}
            link_url_eval {[export_vars -base "category-delete" { category_id { return_url [ad_return_url] } }]}
            link_html { title "[_ lars-blogger._Delete]" }
            sub_class narrow
        }
    }

db_multirow -extend { num_entries_pretty } categories categories {} {
    set num_entries_pretty [lc_numeric $num_entries]
}
