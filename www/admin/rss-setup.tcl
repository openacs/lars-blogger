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

    set subscr_id [db_string create_subscr {}]
    
    db_dml update_subscr {}

}

ad_returnredirect .