ad_library {
    Weblog support routines

    @author Lars Pind (lars@pinds.com)
    @creation-date 2002
    @cvs-id $Id$
}

namespace eval lars_blogger::instance {}

ad_proc -public lars_blogger::instance::add_ping_url {
    -package_id
    -ping_url:required
} {
    Adds a ping URL to a weblogger instance.
    
    @author Guan Yang
} {
    if { ![info exists package_id] } {
        set package_id [ad_conn package_id]
    }
    
    db_dml add_ping_url ""
}

ad_proc -public lars_blogger::instance::remove_ping_url {
    -package_id
    -ping_url:required
} {
    Removes a ping URL from a weblogger instance.
    
    @author Guan Yang
} {
    if { ![info exists package_id] } {
        set package_id [ad_conn package_id]
    } 
    
    db_dml remove_ping_url ""
}

ad_proc -public lars_blogger::instance::get_ping_urls {
    -package_id
} {
    Returns the ping URLs associated with a weblogger instance.
    
    @author Guan Yang
} {
    if { ![info exists package_id] } {
        set package_id [ad_conn package_id]
    }
    
    set ping_urls [db_list get_ping_urls ""]
    
    return $ping_urls
}

ad_proc -private lars_blogger::instance::send_pings {
    -package_id
} {
    Send XML-RPC pings to all the URLs that are registered for
    the present lars_blogger instance.
    
    @author Guan Yang (guan@unicast.org)
    @author Jerry Asher (jerry@theashergroup.com)
    @author Lars Pind (lars@pinds.com)
} {
    if { ![info exists package_id] } {
        set package_id [ad_conn package_id]
    }
    
    set package_url [lars_blog_public_package_url -package_id $package_id]

    set blog_title [lars_blog_name]
    set blog_url "[ad_url]$package_url"
    
    set ping_urls [lars_blogger::instance::get_ping_urls \
                                            -package_id $package_id]
    
    set success_p 1

    ns_log debug "lars_blogger::instance::send_pings:"
    foreach ping_url $ping_urls {
        ns_log debug "lars_blogger::instance::send_pings: call is \n[list xmlrpc::remote_call $ping_url weblogUpdates.ping -string [ad_quotehtml $blog_title] -string [ad_quotehtml $blog_url]]"
        if { [catch {xmlrpc::remote_call $ping_url weblogUpdates.ping -string [ad_quotehtml $blog_title] -string [ad_quotehtml $blog_url] } errmsg ] } {
            ns_log warning "lars_blogger::instance::send_pings error: $errmsg"
            set success_p 0
        } else {
            array set result $errmsg
            if { $result(flerror) } {
                # got an error
                ns_log warning "lars_blogger::instance::send_pings error: $result(message)"
                set success_p 0
            } else {
                # success
                ns_log debug "lars_blogger::instance::send_pings success: $result(message)"
            }
        }
    }
    
    if { $success_p } {
        return 1
    } else {
        return -1
    }
}

