ad_page_contract {} {
    category_id:integer
    {return_url ""}
}

permission::require_permission -object_id [ad_conn package_id] -privilege write

db_exec_plsql delete {}


ad_returnredirect $return_url

