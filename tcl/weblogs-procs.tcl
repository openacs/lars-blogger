ad_library {
    Weblog support routines

    @author Lars Pind (lars@pinds.com)
    @creation-date 2002
    @cvs-id $Id$
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
    if { [catch {xmlrpc::remote_call \
                     $location weblogUpdates.ping \
                     -string [ad_quotehtml $blog_title] \
                     -string [ad_quotehtml $blog_url] } errmsg ] } {
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
