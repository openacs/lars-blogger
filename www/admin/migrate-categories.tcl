ad_page_contract -properties {
    context_bar
} {
    @author bdolicki@branimir.com
    @cvs-id $Id$
} {}

set package_id [ad_conn package_id]

set admin_p [ad_require_permission $package_id admin]

set context {{Categories Migration}}

set title "Categories Migration"

set fp [open [ns_info pageroot]/../packages/lars-blogger/www/admin/migrate-categories-1.tcl]
set meat [read $fp]
close $fp
