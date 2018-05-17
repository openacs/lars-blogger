ad_library {
    Category Tcl API
}

namespace eval lars_blogger {}
namespace eval lars_blogger::category {}

ad_proc lars_blogger::category::new {
    {-package_id ""}
    {-name:required}
    {-category_id ""}
    {-short_name ""}
} {
    @return category_id of new category
} {
    set creation_user [ad_conn user_id]
    set creation_ip [ns_conn peeraddr]

    if { $category_id eq "" } {
        set category_id [db_nextval acs_object_id_seq]
    }
    if { $package_id eq "" } {
        set package_id [ad_conn package_id]
    }
    if { $short_name eq "" } {
        set existing_short_names [lars_blogger::category::get_existing_short_names -package_id $package_id]
        set short_name [util_text_to_url -existing_urls $existing_short_names -text $name]
    }
    
    return [db_exec_plsql insert_category {}]
}

ad_proc lars_blogger::category::edit {
    {-category_id:required}
    {-name:required}
    {-short_name ""}
} {
    @return category_id of new category
} {
    return [db_dml update_category {}]
}

ad_proc lars_blogger::category::get_existing_short_names {
    {-package_id ""}
} {
    return [db_list short_names {}]
}

ad_proc lars_blogger::category::get_id_by_name {
    {-package_id:required}
    {-name:required}
} {
    Returns category ID from name (not short_name)
} {
    return [db_string select_category_id {} -default {}]
}
