ad_library {
    Test cases for the entry API.
}

aa_register_case -cats {api db smoke} rss_generation { 
    Test RSS generation
} {
    # Test case written to expose bug in RSS datasource generation: 
    # The queries had not been updated to get category name.
    
    aa_run_with_teardown \
        -rollback \
        -test_code {
            
            # Setup a screen_name
            set screen_name [ad_generate_random_string]
            acs_user::update -user_id [ad_conn user_id] -screen_name $screen_name

            # Generate a node name
            set node_name [site_node::verify_folder_name \
                               -parent_node_id [site_node::get_node_id -url /] \
                               -instance_name "Weblogger"]
            
            # Create a package
            set package_id [site_node::instantiate_and_mount \
                                -package_key "lars-blogger" \
                                -node_name $node_name]
            
            # Create a category
            set category_name [ad_generate_random_string]
            set category_id [lars_blogger::category::new \
                                 -name $category_name]

            # Configure to set up a package and user RSS feed
            parameter::set_value -parameter "package_rss_feed_p" -package_id $package_id -value 1
            parameter::set_value -parameter "user_rss_feed_p" -package_id $package_id -value 1
            
            # Create an entry
            set content [ad_generate_random_string]
            set entry_id [lars_blogger::entry::new \
                              -package_id $package_id \
                              -title "Testing" \
                              -category_id $category_id \
                              -content $content \
                              -draft_p "f"]

            lars_blogger::entry::get \
                -entry_id $entry_id \
                -array entry

            aa_equals "Entry content is correct" $entry(content) $content
            aa_equals "Entry category is correct" $entry(category_name) $category_name
            
            # Force a rebuild of the RSS feeds
            lars_blogger::rss::generate -package_id $package_id

            # Check that we have to RSS subscriptions
            set subscr_ids [lars_blogger::rss::get_subscr_id_list -package_id $package_id]
            aa_equals "Two RSS subscriptions (one package, one user)" [llength $subscr_ids] 2

            # Find the directory, and verify that it exists
            foreach subscr_id $subscr_ids {
                set report_dir [rss_gen_report_dir -subscr_id $subscr_id]
                set report_file $report_dir/rss.xml
                aa_true "Report file $report_file exists" [file exists $report_file]
            }
        }
}
