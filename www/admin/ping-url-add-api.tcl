ad_page_contract {
    Add a ping_url directly
} {
    ping_url
}

lars_blogger::instance::add_ping_url \
    -package_id [ad_conn package_id] \
    -ping_url $ping_url

ad_returnredirect -message "Ping URL \"$ping_url\" has been added." ping-urls
