ad_page_contract {} {
    entry_id:integer
    {return_url "index"}
}

db_dml update_entry { *SQL* }

# Notifications
lars_blogger::entry::do_notifications -entry_id $entry_id

# Ping weblogs.com
lars_blog_weblogs_com_update_ping

# Flush cache
lars_blog_flush_cache

ad_returnredirect $return_url
