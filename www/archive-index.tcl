ad_page_contract {
    Blog archive index page.

    @author Lars Pind (lars@pinds.com)
    @created June 1, 2002
} -properties {
    page_title:onevalue
    context_bar:onevalue
    months:multirow
}

set package_id [ad_conn package_id]

set page_title "[db_string package_name { *SQL* }] Archive"

set context_bar [ad_context_bar "Archive"]

ad_return_template
