ad_page_contract {
    Add a ping URL.
    
    @author Guan Yang (guan@unicast.org)
    @creation-date 2003-12-13
}

set package_id [ad_conn package_id]

set context [list [list "ping-urls" "Ping URLs"] "Add Ping URL"]

set blog_name [lars_blog_name]
set default_ping_url [parameter::get -package_id $package_id \
                          -parameter "weblogs_ping_url"]

ad_form -name ping_url_add -form {
    {ping_url:text  {label "URL"}
                    {help_text "For example $default_ping_url"}
                    {html {size 40}}}
} -validate {
    {ping_url
        {[util_url_valid_p $ping_url]}
        "Ping URL must be a valid URL"}
} -on_submit {
    
    lars_blogger::instance::add_ping_url \
        -package_id $package_id \
        -ping_url $ping_url
} -after_submit {
    ad_returnredirect -message "Ping URL \"$ping_url\" has been added."  "ping-urls"
}
