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
    -row_pretty_plural "URLs" \
    -actions {
        "Add Ping URL" "ping-url-add" "Add another ping-compatible site"
    } -elements {
        ping_url {
            label "Ping URL"
        }
        remove_url {
            label ""
            display_template {<a onclick="if (confirm('Are you sure that you want to delete this ping URL?')) return true; else return false;" href="@ping_urls.remove_url@">Remove</a>}
        }
    }
    
set blog_name [lars_blog_name]
set context "Ping URLs"

multirow create ping_urls ping_url remove_url

foreach ping_url $ping_urls {
    multirow append ping_urls $ping_url "ping-url-remove?[export_vars -url ping_url]"
}