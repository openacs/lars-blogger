ad_page_contract {
    Add/edit a blogroll link.
    
    @author Guan Yang (guan@unicast.org)
    @creation-date 2003-12-14
} {
    link_id:naturalnum,notnull,optional
}

set package_id [ad_conn package_id]
set user_id [ad_conn user_id]
set ip [ns_conn peeraddr]

set blog_name [lars_blog_name]
set context [list [list "blogroll" "Blogroll"] "One Link"]

ad_form -name entry_form -form {
    link_id:key
    {name:text      {label "Name"}
                    {html {size 40}}}
    {url:text       {label "URL"}
                    {html {size 40}}}
} -validate {
    {name
        {[string length $name] <= 100}
        "Name must be less than 100 characters."}
    {url
        {[string length $url] <= 500}
        "URL must be less than 500 characters."}
} -new_data {
    db_exec_plsql link_add "" 
} -edit_data {
    db_dml link_edit ""
} -after_submit {
    ad_returnredirect "blogroll"
} -select_query_name link_select