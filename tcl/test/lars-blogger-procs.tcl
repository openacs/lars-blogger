ad_library {
    Automated tests.

    @author Simon Carstensen
    @creation-date 11 November 2003
    @cvs-id $Id$
}

aa_register_case lars_blog_add_entry -cats {smoke api db} {
    Test the lars_blogger::entry::new proc
} {    

    aa_run_with_teardown \
        -rollback \
        -test_code {

            # Initialize variables
            set entry_id [db_nextval "acs_object_id_seq"]
            set package_id [ad_conn package_id]

            # Add entry
            set entry_id [lars_blogger::entry::new \
                              -entry_id $entry_id \
                              -package_id $package_id \
                              -title "Foobar" \
                              -content "Just a test" \
                              -content_format "text/plain" \
                              -entry_date "2003-11-11 13:01:01" \
                              -draft_p t]

            set success_p [db_string success_p {
                select 1 from pinds_blog_entries where entry_id = :entry_id
            } -default "0"]

            aa_equals "entry was added succesfully" $success_p 1
        }
}
