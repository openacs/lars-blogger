ad_page_contract {} {
    entry_id:integer
    {return_url ""}
}

db_dml delete {
    update pinds_blog_entries
    set deleted_p = 't'
    where entry_id = :entry_id
}

ad_returnredirect $return_url