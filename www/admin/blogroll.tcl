ad_page_contract {
    View the blogroll for the current weblogger instance.
    
    @author Guan Yang (guan@unicast.org)
    @creation-date 2003-12-14
}

set context [list "[_ lars-blogger.Blogroll]"]
set blog_name [lars_blog_name]

set package_id [ad_conn package_id]

list::create \
    -name links \
    -multirow links \
    -key link_id \
    -row_pretty_plural "[_ lars-blogger.links]" \
    -actions {
        "#lars-blogger.Add_Link#" "blogroll-ae" "#lars-blogger.lt_Add_a_link_to_your_bl#"
    } -elements {
        edit {
            sub_class narrow
            label ""
            display_template {
                <img src="/shared/images/Edit16.gif" height="16" width="16" border="0">
            }
            link_url_col edit_link
        }
        name {
            label "[_ lars-blogger.Name]"
        }
        url {
            label "[_ lars-blogger.URL]"
            display_template {
                <a href="@links.url@">@links.url@</a>
            }
        }
        order {
            label "[_ lars-blogger.Order]"
            display_template {
                <a href="@links.move_up_link@">[_ lars-blogger.Up]</a>
                <a href="@links.move_down_link@">[_ lars-blogger.Down]</a>
            }
        }
        delete {
            label ""
            sub_class narrow
            display_template {
                <a onclick="if (confirm('[_ lars-blogger.lt_Are_you_sure_that_you]')) return true; else return false;" href="@links.delete_link@"><img src="/shared/images/Delete16.gif" height="16" width="16" border="0"></a>
            }
        }
    }

db_multirow -extend {
    move_up_link
    move_down_link
    delete_link
    edit_link
} links links_select "" {
    set move_up_link [export_vars -base blogroll-move {link_id {direction up}}]
    set move_down_link [export_vars -base blogroll-move {link_id {direction down}}]
    set delete_link [export_vars -base blogroll-delete link_id]
    set edit_link [export_vars -base blogroll-ae link_id]
}

