ad_page_contract {
    Setup an RSS feed for this blogger.
}

set creation_user [ad_conn user_id]
set creation_ip [ns_conn peeraddr]

# by default, we timout in 30 minutes
set timeout [expr 30*60]

set package_id [ad_conn package_id]

set channel_title [lars_blog_name]
set channel_link [lars_blog_public_package_url]

db_transaction {

    if { [empty_string_p [parameter::get -parameter "rss_file_name"]] } {
        parameter::set_value -parameter "rss_file_name" -value "rss/rss.xml"
    } 

    set subscr_id [db_exec_plsql create_subscr {}]
    
    db_dml update_subscr {}

}

# Run it now
rss_gen_report $subscr_id

ad_returnredirect .
