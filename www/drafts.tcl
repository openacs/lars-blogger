ad_page_contract {} {
} -properties {
    context_bar
}

set package_id [ad_conn package_id]
set user_id [ad_conn user_id]

set page_title "Draft Entries"

set context [list $page_title]

set elements [list]
lappend elements edit {
    label {}
    sub_class narrow
    display_template {
        <img src="/resources/acs-subsite/Edit16.gif" height="16" width="16" border="0">
    }
    link_url_eval {[export_vars -base entry-edit { entry_id { return_url [ad_return_url] } }]}
    link_html { title "Edit entry" }
}
lappend elements entry_date {
    label "Date"
    display_col entry_date_pretty
}

if { [permission::permission_p -object_id $package_id -privilege write] } {
    set statement "all_draft_entries"
    lappend elements creation_user {
        label "Author"
        display_template {@entries.first_names@ @entries.last_name@}
        link_url_eval {[acs_community_member_url -user_id $creation_user]}
    }
} else {
    set statement "draft_entries"
}

lappend elements content {
    label "Entry"
    link_url_eval {[export_vars -base one-entry { entry_id { return_url [ad_return_url] } }]}
    link_html { title "Preview entry" }
}
lappend elements publish {
    label {Publish}
    sub_class narrow
    display_template {
        Publish
    }
    link_url_eval {[export_vars -base entry-publish { entry_id { return_url [ad_return_url] } }]}
    link_html { title "Publish entry" }
    html { align center }
}
lappend elements delete {
    label {}
    sub_class narrow
    display_template {
        <img src="/resources/acs-subsite/Delete16.gif" height="16" width="16" border="0">
    }
    link_url_eval {[export_vars -base entry-delete { entry_id { return_url [ad_return_url] } }]}
    link_html { title "Delete entry" }
}


template::list::create \
    -name entries \
    -multirow entries \
    -elements $elements

db_multirow -extend { entry_date_pretty edit_url publish_url delete_url preview_url } entries $statement {} {
    set entry_date_pretty [lc_time_fmt $entry_date_ansi "%q"]
    set content [string_truncate -len 80 -- $content]
}

set entry_add_url "entry-edit"

set arrow_url "[ad_conn package_url]graphics/arrow-box.gif"

set header_background_color [lars_blog_header_background_color]


