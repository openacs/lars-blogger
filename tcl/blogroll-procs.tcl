ad_library {
    API for blogroll management in weblogger.
    
    @author Guan Yang (guan@unicast.org)
    @creation-date 2003-12-14
}

namespace eval lars_blogger {}
namespace eval lars_blogger::blogroll {}

ad_proc lars_blogger::blogroll::delete_from_package {
    -package_id
} {
    Deletes all blogroll entries for the given package.
    
    @author Guan Yang (guan@unicast.org)
} {
    if { ![info exists package_id] } {
        set package_id [ad_conn package_id]
    }
    
    db_foreach delete_from_package "" {}
}