ad_page_contract {} {
    entry_id:integer
    {return_url ""}
}

lars_blogger::entry::require_write_permission -entry_id $entry_id

db_dml delete {
    update pinds_blog_entries
    set deleted_p = 't'
    where entry_id = :entry_id
}


ad_returnredirect $return_url
