ad_page_contract {} {
    entry_id:integer
    {return_url "."}
}

lars_blogger::entry::delete -entry_id $entry_id

ad_returnredirect $return_url
