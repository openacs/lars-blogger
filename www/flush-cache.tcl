ad_page_contract {
    Flush the blog  cache.
} {
    {return_url .}
}

lars_blog_flush_cache [ad_conn package_id]

ad_returnredirect $return_url


