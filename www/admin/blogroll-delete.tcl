ad_page_contract {
    Delete a blogroll link.
    
    @author Guan Yang (guan@unicast.org)
    @creation-date 2003-12-14
} {
    link_id:naturalnum,notnull
}

set package_id [ad_conn package_id]

# Check that the link belongs to this package; if not
# redirect back to blogroll
if { [db_string link_select "" -default 0] != $package_id } {
    ad_returnredirect "blogroll"
    ad_script_abort
}

db_1row link_delete ""

ad_returnredirect "blogroll"
