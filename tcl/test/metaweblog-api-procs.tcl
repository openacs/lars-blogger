# /packages/lars-blogger/tcl/test/metaweblog-api-procs.tcl
ad_library {
     Test the MetaWeblog API
     @author Vinod Kurup [vinod@kurup.com]
     @creation-date Sun Nov 30 22:15:14 2003
     @cvs-id $Id$
}

aa_register_case -cats web -init_classes {
    create_blog_and_user
} mw_new_get_edit_post {
    Test new, edit and get post functions. 
    metaWeblog.newPost, metaWeblog.editPost, metaWeblog.getPost, metaWeblog.getRecentPosts
} {
    set url [ad_url][xmlrpc::url]

    set orig_content_text "<b>[ad_generate_random_string]</b>"
    set new_content_text "<b>[ad_generate_random_string]</b>"

    # put them into arrays
    set orig_content(description) [list -string $orig_content_text]
    set new_content(description) [list -string $new_content_text]

    set publish_p 1

    aa_run_with_teardown -rollback -test_code {
        # create an entry
        set entry_id [xmlrpc::remote_call $url metaWeblog.newPost \
                          -string $blog_id \
                          -string $username \
                          -string $password \
                          -struct [array get orig_content] \
                          -boolean $publish_p]

        aa_true "New entry added successfully" [string is integer $entry_id]
        
        # Test entry via normal API
        array set new_entry [list]
        lars_blogger::entry::get -entry_id $entry_id -array new_entry

        aa_equals "New entry content correct" \
            $new_entry(content) $orig_content_text

        # Test entry via MetaWeblog API
        array set get_entry [xmlrpc::remote_call $url metaWeblog.getPost \
                                 -string $entry_id \
                                 -string $username \
                                 -string $password]

        aa_equals "Content correct via getPost" \
            $get_entry(description) $orig_content_text

        # Edit the entry
        xmlrpc::remote_call $url metaWeblog.editPost \
            -string $entry_id \
            -string $username \
            -string $password \
            -struct [array get new_content] \
            -boolean $publish_p
            
        array set edited_entry [list]
        lars_blogger::entry::get -entry_id $entry_id -array edited_entry

        aa_equals "Edited content is correct" \
            $edited_entry(content) $new_content_text

        # Add 2 posts and then get them via getRecentPosts

        set content1_text [ad_generate_random_string]
        set content1(description) [list -string $content1_text]
        set content2_text [ad_generate_random_string]
        set content2(description) [list -string $content2_text]

        set entry1_id [xmlrpc::remote_call $url metaWeblog.newPost \
                           -string $blog_id \
                           -string $username \
                           -string $password \
                           -struct [array get content1] \
                           -boolean $publish_p]

        set entry2_id [xmlrpc::remote_call $url metaWeblog.newPost \
                           -string $blog_id \
                           -string $username \
                           -string $password \
                           -struct [array get content2] \
                           -boolean $publish_p]

        set entry_list [xmlrpc::remote_call $url metaWeblog.getRecentPosts \
                            -string $blog_id \
                            -string $username \
                            -string $password \
                            -int 2]

        array set result2 [lindex $entry_list 0]
        aa_equals "Get most recent post" $result2(description) $content2_text
        array set result1 [lindex $entry_list 1]
        aa_equals "Get 2nd most recent post" $result1(description) $content1_text
    }
}
