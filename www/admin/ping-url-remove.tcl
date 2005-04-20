ad_page_contract {
    Remove a ping URL.
    
    @author Guan Yang (guan@unicast.org)
    @creation-date 2003-12-13
} {
    ping_url:notnull
}

set package_id [ad_conn package_id]

catch {
    lars_blogger::instance::remove_ping_url \
                                -package_id $package_id \
                                -ping_url $ping_url
}

ad_returnredirect -message "[_ lars-blogger.lt_Ping_URL_ping_url_has_1]" "ping-urls"
