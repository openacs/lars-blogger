ad_page_contract {} {
    entry_id:naturalnum,notnull
    {return_url "."}
}

permission::require_write_permission -object_id $entry_id

lars_blogger::entry::publish \
    -entry_id $entry_id \
    -redirect_url $return_url

