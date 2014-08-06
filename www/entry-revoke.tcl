ad_page_contract {} {
    entry_id:naturalnum,notnull
    {return_url "."}
}

lars_blogger::entry::draft -entry_id $entry_id

ad_returnredirect $return_url
