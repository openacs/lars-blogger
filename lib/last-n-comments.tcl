ad_page_element_contract {
    Dipslay the mini-calendar for a blog
} {
    {package_id:optional {[ad_conn package_id]}}
    number_of_comments:optional
}

if { ![exists_and_not_null number_of_comments] || $number_of_comments == 0 } {
    set number_of_comments [parameter::get \
                                -default 10 \
                                -package_id $package_id \
                                -parameter NumberOfCommentsInIncludelet]
}

db_multirow -extend { entry_url } comments select_n_comments {} {
    set entry_url [export_vars -base "[ad_url][lars_blog_public_package_url -package_id $package_id]/one-entry" { entry_id }]
}
