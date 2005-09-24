ad_page_contract {
    Add a ping URL.
    
    @author Guan Yang (guan@unicast.org)
    @creation-date 2003-12-13
}

set package_id [ad_conn package_id]

set context [list [list "ping-urls" "[_ lars-blogger.Ping_URLs]"] "[_ lars-blogger.Add_Ping_URL]"]

set blog_name [lars_blog_name]
set default_ping_url [parameter::get -package_id $package_id \
                          -parameter "weblogs_ping_url"]

ad_form -name ping_url_add -form {
    {ping_url:text  {label "[_ lars-blogger.URL]"}
                    {help_text "[_ lars-blogger.lt_For_example_default_p]"}
                    {html {size 40}}}
} -validate {
    {ping_url
        {[util_url_valid_p $ping_url]}
        "[_ lars-blogger.lt_Ping_URL_must_be_a_va]"}
} -on_submit {
    
    lars_blogger::instance::add_ping_url \
        -package_id $package_id \
        -ping_url $ping_url
} -after_submit {
    ad_returnredirect -message "[_ lars-blogger.lt_Ping_URL_ping_url_has]"  "ping-urls"
}
