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
    
    # Should we ping?
    set ping_p [parameter::get -boolean \
                    -package_id $package_id \
                    -parameter "weblogs_update_ping_p" \
                    -default 0]

    if { !$ping_p } {
        return
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
    
ad_proc -private lars_blog_weblogs_com_update_ping {
    {-package_id ""}
    {-location}
} {
    Sends the xml/rpc message weblogUpdates.ping to weblogs.com
    returns 1 if successful and logs the result.
    @author Jerry Asher (jerry@theashergroup.com)
    @author Lars Pind (lars@pinds.com)
} {
    if { ![exists_and_not_null package_id] } {
        set package_id [ad_conn package_id]
    }

    set package_url [lars_blog_public_package_url -package_id $package_id]

    # Should we ping?
    set ping_p [parameter::get -boolean \
                    -package_id $package_id \
                    -parameter "weblogs_update_ping_p" \
                    -default 0]

    if { !$ping_p } {
        return
    }
    
    if { ![info exists location] } {
        set location [parameter::get -package_id $package_id \
                          -parameter "weblogs_ping_url"]
    }
    if { [empty_string_p $location] } {
        ns_log Error "lars_blog_weblogs_com_update_ping: No URL to ping"
        return
    }

    set blog_title [db_string package_name {}]
    set blog_url "[ad_url]$package_url"

    ns_log debug "lars_blog_weblogs_com_update_ping:"
    if { [catch {xmlrpc::remote_call -timeout 60 $location weblogUpdates.ping -string [ad_quotehtml $blog_title] -string [ad_quotehtml $blog_url]} errmsg ] } {
        ns_log warning "lars_blog_weblogs_com_update_ping error: $errmsg"
        return -1
    } else {
        array set result $errmsg
        if { $result(flerror) } {
            # got an error
            ns_log warning "lars_blog_weblogs_com_update_ping error: $result(message)"
            return -1
        } else {
            # success
            ns_log debug "lars_blog_weblogs_com_update_ping success: $result(message)"
            return 1
        }
    }
}
