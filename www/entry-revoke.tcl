ad_page_contract {} {
    entry_id:integer
    {return_url "index"}
}

db_dml update_entry { *SQL* }

ad_returnredirect $return_url
ns_conn close

# Flush cache
lars_blog_flush_cache
