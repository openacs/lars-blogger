ad_page_contract {} {
    category_id:naturalnum,notnull
    {return_url ""}
}

# Must have admin privilege (since categories are package-wide, not just per user)
permission::require_permission -object_id [ad_conn package_id] -privilege admin

db_exec_plsql delete {}

ad_returnredirect $return_url

