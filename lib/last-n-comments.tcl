set package_id [ad_conn package_id]

if { ![info exists number_of_comments] || $number_of_comments eq "" || $number_of_comments == 0 } {
    set number_of_comments [parameter::get \
                                -default 10 \
                                -parameter NumberOfCommentsInIncludelet]
}

set entry_base [ad_url][lars_blog_public_package_url]/one-entry 
db_multirow -extend {entry_url} comments select_n_comments "" {
    set entry_url [export_vars -base $entry_base entry_id]
}
