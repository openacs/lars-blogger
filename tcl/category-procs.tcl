ad_library {
    Category Tcl APi
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

    if { [empty_string_p $category_id] } {
        set category_id [db_nextval acs_object_id_seq]
    }
    if { [empty_string_p $package_id] } {
        set package_id [ad_conn package_id]
    }
    if { [empty_string_p $short_name] } {
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
    return [db_exec_plsql update_category {}]
}

ad_proc lars_blogger::category::get_existing_short_names {
    {-package_id ""}
} {
    return [db_list short_names {}]
}

