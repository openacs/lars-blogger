ad_library {
    Weblog support routines

    @author Lars Pind (lars@pinds.com)
    @creation-date 2002
    @cvs-id $Id$
}

ad_proc -private lars_blog_weblogs_com_update_ping {
    {-package_id ""}
    {-location}
    {-timeout 30}
    {-depth 0}
} {
    Sends the xml/rpc message weblogUpldates.ping to weblogs.com
    returns 1 if successful and logs the result.
    @author Jerry Asher (jerry@theashergroup.com)
    @author Lars Pind (lars@pinds.com)
} {
    set package_url [lars_blog_public_package_url -package_id $package_id]

    if { ![exists_and_not_null package_id] } {
        set package_id [ad_conn package_id]
    }

    # Should we ping?
    set ping_p [ad_parameter -package_id $package_id "weblogs_update_ping_p" "lars-blogger" 0]
    if { !$ping_p } {
        return
    }
    
    if { ![info exists location] } {
        set location [ad_parameter -package_id $package_id "weblogs_ping_url"]
    }
    if { [empty_string_p $location] } {
        ns_log Error "lars_blog_weblogs_com_update_ping: No URL to ping"
        return
    }

    set blog_title [db_string package_name { *SQL* }]

    set blog_url "[ad_url]$package_url"

    ns_log notice "lars_blog_weblogs_com_update_ping:"
    if [catch {
        if {[incr depth] > 10} {
            return -code error "rss_weblogUpdatesping:  Recursive redirection:  $location"
        }
        set req_hdrs [ns_set create]

        set message "<?xml version=\"1.0\"?>
<methodCall>
  <methodName>weblogUpdates.ping</methodName>
  <params>
    <param>
      <value>[ad_quotehtml $blog_title]</value>
    </param>
    <param>
      <value>[ad_quotehtml $blog_url]</value>
    </param>
  </params>
</methodCall>"

        # headers necesary for a post and the form variables
        ns_set put $req_hdrs "Content-type" "text/xml"
        ns_set put $req_hdrs "Content-length" [string length $message]
        set http [ns_httpopen POST $location $req_hdrs 30 $message]
        set rfd [lindex $http 0]
        set wfd [lindex $http 1]
        set rpset [lindex $http 2]

        flush $wfd
        close $wfd

    ns_log notice "lars_blog_weblogs_com_update_ping: pinging for blog $blog_title and url $blog_url"
    ns_log notice message: \"$message\"

        set headers $rpset
        set response [ns_set name $headers]
        set status [lindex $response 1]
if {$status == 302} {
            set location [ns_set iget $headers location]
    if {$location != ""} {
                ns_set free $headers
                close $rfd
                return [lars_blog_weblogs_com_update_ping -package_id $package_id -location $location -timeout $timeout -depth $depth]
    }
}
        set length [ns_set iget $headers content-length]
if [string match "" $length] {set length -1}
        set err [catch {
            while 1 {
                set buf [_ns_http_read $timeout $rfd $length]
                append page $buf
                if [string match "" $buf] break
                if {$length > 0} {
                    incr length -[string length $buf]
                    if {$length <= 0} break
                }
            }
        } errMsg]
        ns_set free $headers
        close $rfd
        if $err {
            global errorInfo
            return -code error -errorinfo $errorInfo $errMsg
        }
    } errmsg ] {
        ns_log warning "lars_blog_weblogs_com_update_ping error: $errmsg"
        return -1
    } else {
        ns_log notice "lars_blog_weblogs_com_update_ping: $page"
        return 1
    }
}


