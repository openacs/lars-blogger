ad_page_contract {} {
    entry_id:integer
    {return_url "index"}
}

lars_blogger::entry::require_write_permission -entry_id $entry_id

lars_blogger::entry::publish \
    -entry_id $entry_id \
    -redirect_url $return_url

