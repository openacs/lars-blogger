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
set context [list [list "blogroll" "[_ lars-blogger.Blogroll]"] "[_ lars-blogger.One_Link]"]

ad_form -name entry_form -form {
    link_id:key
    {name:text      {label "[_ lars-blogger.Name]"}
                    {html {size 40}}}
    {url:text       {label "[_ lars-blogger.URL]"}
                    {html {size 40}}}
} -validate {
    {name
        {[string length $name] <= 100}
        "[_ lars-blogger.lt_Name_must_be_less_tha]"}
    {url
        {[string length $url] <= 500}
        "[_ lars-blogger.lt_URL_must_be_less_than]"}
} -new_data {
    db_exec_plsql link_add "" 
} -edit_data {
    db_dml link_edit ""
} -after_submit {
    ad_returnredirect "blogroll"
} -select_query_name link_select