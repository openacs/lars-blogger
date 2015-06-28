
ad_library {
    Procs for interfacing the Technorati API.
    
    @author Guan Yang (guan@unicast.org)
    @creation-date 2003-12-14
}

namespace eval lars_blogger {}
namespace eval lars_blogger::technorati {}

ad_proc -private lars_blogger::technorati::scheduled_job { } {
    Calls lars_blogger::technorati::populate_cache for all
    lars-blogger instances.
    
    @author Guan Yang (guan@unicast.org)
    
    @return Empty string
} {
    set instances [db_list blogger_instances ""]
    
    foreach instance $instances {
        lars_blogger::technorati::populate_cache -package_id $instance
    }
    
    return ""
}

ad_proc -private lars_blogger::technorati::populate_cache {
    -package_id
} {
    Attempts to fill the Technorati cache if Technorati API support
    is enabled for the package.
    
    @author Guan Yang (guan@unicast.org)
    
    @return Nothing, even if there's an error.
} {
    if { ![info exists package_id] } {
        set package_id [ad_conn package_id]
    }
    
    set enabled_p [parameter::get \
                        -parameter TechnoratiApiEnabledP \
                        -default 0 \
                        -boolean \
                        -package_id $package_id]
    
    if { !$enabled_p } {
        ns_log Debug "lars_blogger::technorati::populate_cache: Technorati API not enabled (parameter=$enabled_p)"
        return ""
    }
    
    catch {
        set items [lars_blogger::technorati::parse_xml \
                                    -package_id $package_id]
                                    
        ns_log Debug "lars_blogger::technorati::populate_cache: [llength $items] items fetched"
        
        db_transaction {
            db_dml flush_cache ""
            
            foreach item_array $items {
                array set item $item_array
                set name $item(name)
                set url $item(url)
                db_dml cache_insert ""
            }
        }
    } errmsg
    
    ns_log Debug "lars_blogger::technorati::populate_cache: error = $errmsg"
    
    return ""
}

ad_proc -private lars_blogger::technorati::parse_xml {
    -package_id
} {
    Use tDOM to parse the XML file for this package and return
    an array structure.
    
    @author Guan Yang (guan@unicast.org)
    
    @return Special array data structure with the information
            from the Technorati XML file, error on failure
} {
    package require tdom
    
    if { ![info exists package_id] } {
        set package_id [ad_conn package_id]
    }
    
    if { [catch {
        set xml [lars_blogger::technorati::fetch_xml -package_id $package_id]
    } errmsg] } {
        error "fetch_xml error: $errmsg"
    }
    
    if { [catch {

        dom parse $xml doc
        $doc documentElement root

        set root_name [$root nodeName]
        if { $root_name ne "tapi" } {
            error "Root element is not tapi"
        }
        
        set item_nodes [$root selectNodes "document/item"]
        
        set items [list]
        
        # Let's go through each item node and parse it
        set i 0
        foreach item_node $item_nodes {
            set weblog_node [$item_node selectNodes "weblog"]
            if { [llength $weblog_node] != 1 } {
                error "Item $i lacks a weblog child"
            }
            
            set name_node [$weblog_node selectNodes "name"]
            set item(name) [$name_node text]
            
            set url_node [$weblog_node selectNodes "url"]
            set item(url) [$url_node text]
            
            lappend items [array get item]
            
            incr i
        }
    } errmsg] } {
        error "dom parse error: $errmsg"
    } else {
        return $items
    }
}

ad_proc -private lars_blogger::technorati::fetch_xml {
    -package_id
} {
    Fetches the raw XML sources from the Technorati API.

    @author Guan Yang (guan@unicast.org)
    
    @return The XML source. Throws an error on failure.
} {
    if { ![info exists package_id] } {
        set package_id [ad_conn package_id]
    }
    
    #http://api.technorati.com/cosmos?key=d61454cf50000971a9da5d8bed3cfff2&url=http://unicast.org/&type=weblog&version=0.9

    set key [parameter::get \
                    -package_id $package_id \
                    -default "" \
                    -parameter TechnoratiApiKey]
    set url [parameter::get \
                    -package_id $package_id \
                    -default "" \
                    -parameter TechnoratiApiUrl]
    set type "weblog"
    set version "0.9"
    
    if {$key eq ""} {
        error "No Technorati API key available"
    }
    
    if {$url eq ""} {
        set url "[ad_url][lars_blog_public_package_url]"
    }
    
    set api_url [export_vars -base http://api.technorati.com/cosmos [list key url type version]]
    
    array set f [ad_httpget -url $api_url -timeout 60]
    if {$f(status) == 200} {
        return $f(page)
    } else {
        error "ad_httpget error"
    }
}
