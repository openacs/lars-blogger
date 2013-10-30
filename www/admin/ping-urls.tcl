ad_page_contract {
    Set up ping URLs for this blogger instance.
    
    @author Guan Yang (guan@unicast.org)
    @creation-date 2003-12-13
}

set package_id [ad_conn package_id]

set ping_urls [lars_blogger::instance::get_ping_urls -package_id $package_id]

list::create \
    -name ping_urls \
    -multirow ping_urls \
    -key ping_url \
    -row_pretty_plural "[_ lars-blogger.URLs]" \
    -actions {
        "[_ lars-blogger.Add_Ping_URL]" "ping-url-add" "[_ lars-blogger.lt_Add_another_ping-comp]"
    } -elements {
        ping_url {
            label "[_ lars-blogger.Ping_URL]"
        }
        remove_url {
            label ""
            display_template {<a onclick="if (confirm('[_ lars-blogger.lt_Are_you_sure_that_you_1]')) return true; else return false;" href="@ping_urls.remove_url@">[_ lars-blogger.Remove]</a>}
        }
    }
    
set blog_name [lars_blog_name]
set context "[_ lars-blogger.Ping_URLs]"

multirow create ping_urls ping_url remove_url

foreach ping_url $ping_urls {
    multirow append ping_urls $ping_url [export_vars -base ping-url-remove { ping_url }]
}

multirow create default_pings service ping_url
foreach { service ping_url } { 
    "Weblogs.com" "http://rpc.weblogs.com/RPC2" 
    "blo.gs" "http://ping.blo.gs/"
    "Technorati.com" "http://rpc.technorati.com/rpc/ping"
} {
    if {$ping_url ni $ping_urls} {
        multirow append default_pings $service $ping_url
    }
}

template::list::create \
    -name default_pings \
    -elements {
        service {
            label "[_ lars-blogger.Service]"
        }
        ping_url {
            label "[_ lars-blogger.Ping_URL]"
        }
        add {
            display_template {Add}
            link_url_eval {[export_vars -base ping-url-add-api { ping_url }]}
        }
    }
