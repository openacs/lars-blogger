# /packages/lars-blogger/tcl/test/blogger-api-procs.tcl
ad_library {
     Test the Blogger API
     @author Vinod Kurup [vinod@kurup.com]
     @creation-date Wed Oct 15 22:39:03 2003
     @cvs-id $Id$
}

aa_register_init_class create_blog_and_user {
    Mount and unmount a test blog
} {
    # constructor

    # export these vars to the environment
    aa_export_vars {blog_id user_id username password}

    # mount the blog
    set node_name [ad_generate_random_string]
    set blog_id [site_node::instantiate_and_mount \
                        -node_name $node_name \
                        -package_key lars-blogger]

    # create the user
    set username [ad_generate_random_string]
    set password [ad_generate_random_string]
    set email "[ad_generate_random_string]@example.com"
    set fn [ad_generate_random_string]
    set ln [ad_generate_random_string]

    array set user [auth::create_user \
                        -username $username \
                        -email $email \
                        -first_names $fn \
                        -last_name $ln \
                        -password $password]
    
    if { [string equal $user(creation_status) ok] } {
        set user_id $user(user_id)
        permission::grant -party_id $user_id \
            -object_id $blog_id \
            -privilege create
    } else {
        aa_error "User creation failed. $user(creation_status) Error: $user(creation_message) $user(element_messages)"
        set user_id ""
    }
} {
    # destructor

    if {[catch { 
        apm_package_instance_delete $blog_id
        acs_user::delete -permanent -user_id $user_id
    } errMsg]} {
        ns_log error "create_blog_and_user teardown failed: $errMsg"
    }
}

aa_register_case -cats web -init_classes {
    create_blog_and_user
} blogger_new_post {
    Make a new post.
    Tests blogger.newPost
} {
    set url [ad_url][xmlrpc::url]
    set appkey ""
    set content "<b>[ad_generate_random_string]</b>"
    set publish_p 1

    aa_run_with_teardown -rollback -test_code {
        set entry_id [xmlrpc::remote_call $url blogger.newPost \
                          -string $appkey \
                          -string $blog_id \
                          -string $username \
                          -string $password \
                          -string $content \
                          -boolean $publish_p]

        aa_true "Entry $entry_id added" [string is integer $entry_id]

        array set entry_info [list]
        lars_blogger::entry::get -entry_id $entry_id -array entry_info

        aa_equals "Entry content is correct" $entry_info(content) $content
    }
}

aa_register_case -cats web -init_classes {
    create_blog_and_user
} blogger_edit_post {
    Edit a post.
    Tests blogger.editPost
} {
    set url [ad_url][xmlrpc::url]
    set appkey ""
    set content_1 "[ad_generate_random_string]"
    set content_2 "[ad_generate_random_string]"
    set publish_p 1

    aa_run_with_teardown -rollback -test_code {
        set entry_id [xmlrpc::remote_call $url blogger.newPost \
                          -string $appkey \
                          -string $blog_id \
                          -string $username \
                          -string $password \
                          -string $content_1 \
                          -boolean $publish_p]

        aa_true "Entry $entry_id added" [string is integer $entry_id]

        xmlrpc::remote_call $url blogger.editPost \
             -string $appkey \
             -string $entry_id \
             -string $username \
             -string $password \
             -string $content_2 \
             -boolean $publish_p
             
        array set entry_info [list]
        lars_blogger::entry::get -entry_id $entry_id -array entry_info

        aa_equals "Edited content is correct" $entry_info(content) $content_2 
    }
}

aa_register_case -cats web -init_classes {
    create_blog_and_user
} blogger_list_user_blogs {
    List blogs to which this user can post.
    Tests blogger.getUsersBlogs
} {
    set url [ad_url][xmlrpc::url]
    set appkey ""

    aa_run_with_teardown -rollback -test_code {
        set blog_list [xmlrpc::remote_call $url blogger.getUsersBlogs \
                          -string $appkey \
                          -string $username \
                          -string $password]

        # Get the first blog in the list
        array set one_blog [lindex $blog_list 0]

        aa_equals "blog_id $blog_id returned" $one_blog(blogid) $blog_id

        # TODO - test multiple blogs with different permissions
    }
}

aa_register_case -cats web -init_classes {
    create_blog_and_user
} blogger_get_user_info {
    Get user info.
    Test blogger.getUserInfo
} {
    set url [ad_url][xmlrpc::url]
    set appkey ""

    aa_run_with_teardown -rollback -test_code {
        array set user_info [xmlrpc::remote_call $url blogger.getUserInfo \
                          -string $appkey \
                          -string $username \
                          -string $password]

        aa_equals "user_id correct" $user_info(userid) $user_id
    }
}

aa_register_case -cats web -init_classes {
    create_blog_and_user
} blogger_get_post {
    Get a single post.
    Test blogger.getPost
} {
    set url [ad_url][xmlrpc::url]
    set appkey ""
    set content "<b>[ad_generate_random_string]</b>"
    set publish_p 1

    aa_run_with_teardown -rollback -test_code {
        set entry_id [xmlrpc::remote_call $url blogger.newPost \
                          -string $appkey \
                          -string $blog_id \
                          -string $username \
                          -string $password \
                          -string $content \
                          -boolean $publish_p]

        array set entry [xmlrpc::remote_call $url blogger.getPost \
                             -string $appkey \
                             -string $entry_id \
                             -string $username \
                             -string $password]

        aa_equals "content correct" $entry(content) $content
        aa_equals "user_id correct" $entry(userid) $user_id
        aa_equals "entry_id correct" $entry(postid) $entry_id
    }
}

aa_register_case -cats web -init_classes {
    create_blog_and_user
} blogger_get_recent_posts {
    Get recent posts.
    Tests blogger.getRecentPosts
} {
    set url [ad_url][xmlrpc::url]
    set appkey ""
    set content1 "<b>[ad_generate_random_string]</b>"
    set content2 "<b>[ad_generate_random_string]</b>"
    set publish_p 1

    aa_run_with_teardown -rollback -test_code {
        set entry1_id [xmlrpc::remote_call $url blogger.newPost \
                          -string $appkey \
                          -string $blog_id \
                          -string $username \
                          -string $password \
                          -string $content1 \
                          -boolean $publish_p]

        set entry2_id [xmlrpc::remote_call $url blogger.newPost \
                          -string $appkey \
                          -string $blog_id \
                          -string $username \
                          -string $password \
                          -string $content2 \
                          -boolean $publish_p]

        # get the entries
        set entry_list [xmlrpc::remote_call $url blogger.getRecentPosts \
                            -string $appkey \
                            -string $blog_id \
                            -string $username \
                            -string $password \
                            -int 2]

        # newest posts are returned first
        array set entry2 [lindex $entry_list 0]
        array set entry1 [lindex $entry_list 1]

        aa_equals "content 2 correct" $entry2(content) $content2
        aa_equals "entry_id 2 correct" $entry2(postid) $entry2_id

        aa_equals "content 1 correct" $entry1(content) $content1
        aa_equals "entry_id 1 correct" $entry1(postid) $entry1_id
    }
}

aa_register_case -cats web -init_classes {
    create_blog_and_user
} blogger_delete_post {
    Delete post.
    Tests blogger.deletePost
} {
    set url [ad_url][xmlrpc::url]
    set appkey ""
    set content "<b>[ad_generate_random_string]</b>"
    set publish_p 1

    aa_run_with_teardown -rollback -test_code {
        set entry_id [xmlrpc::remote_call $url blogger.newPost \
                          -string $appkey \
                          -string $blog_id \
                          -string $username \
                          -string $password \
                          -string $content \
                          -boolean $publish_p]

        array set entry [xmlrpc::remote_call $url blogger.getPost \
                             -string $appkey \
                             -string $entry_id \
                             -string $username \
                             -string $password]

        aa_equals "entry_id correct" $entry(postid) $entry_id
        array unset entry

        set result [xmlrpc::remote_call $url blogger.deletePost \
                            -string $appkey \
                            -string $entry_id \
                            -string $username \
                            -string $password \
                            -boolean $publish_p]

        aa_true "delete succeeded" $result

        array set entry [xmlrpc::remote_call $url blogger.getPost \
                             -string $appkey \
                             -string $entry_id \
                             -string $username \
                             -string $password]

        aa_false "entry_id gone" [info exists entry(postid)]
    }
}
