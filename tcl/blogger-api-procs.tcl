# /packages/lars-blogger/tcl/blogger-api-procs.tcl
ad_library {
    Support the Blogger API
    http://www.blogger.com/developers/api/1_docs/

     @author Vinod Kurup [vinod@kurup.com]
     @creation-date Fri Oct  3 21:26:11 2003
     @cvs-id $Id$
}

# Helper procs

ad_proc lars_blog_auth_for_xmlrpc {
    -username
    -password
} {
    Authenticate a user based on info from XML-RPC client. Not sure if we're
    getting email or username, so test for @ and decide.

    @returns user_id if successful authentication. errors if unsuccesful.
    @author Vinod Kurup
} {
    if { [string first "@" $username] != -1 } {
        # use email auth
        array set auth [auth::authenticate -email $username \
                            -password $password]
    } else {
        # use username auth
        array set auth [auth::authenticate -username $username \
                            -password $password]
    }

    if { $auth(auth_status) != "ok" } {
        return -code error $auth(auth_message)
    }

    return $auth(user_id)
}

# Blogger API 1.0 Methods

ad_proc -public blogger.newPost {
    appkey
    package_id
    username
    password
    content
    publish_p
} {
    <strong>From Blogger API documentation:</strong>
    <p>
    blogger.newPost makes a new post to a designated blog. Optionally, will 
    publish the blog after making the post. On success, it returns the unique 
    ID of the new post. On error, it will return some error message.
    </p>

    <p>
    OpenACS Notes: lars-blogger requires title, but we don't get one from 
    XML-RPC. So, leave title as " " for now. User will have to manually edit 
    it later if needed.
    </p>    

    @param appkey (string): Ignored in OpenACS
    @param package_id (string): Blog's package_id
    @param username (string): email or username for a user who has permission 
    to post to the blog.
    @param password (string): Password for said username/email
    @param content (string): Contents of the post
    @param publish_p (boolean): If true, the blog will be published 
    immediately after the post is made.

    @return returns entry_id for new post.
} {
    set user_id [lars_blog_auth_for_xmlrpc \
                     -username $username \
                     -password $password]

    permission::require_permission -party_id $user_id \
        -object_id $package_id \
        -privilege create

    set entry_id [db_nextval t_acs_object_id_seq]
    set entry_date [clock format [clock seconds] -format %Y-%m-%d]

    return [list -string [lars_blog_entry_add -entry_id $entry_id \
                           -package_id $package_id \
                           -title " " \
                           -content $content \
                           -content_format "text/html" \
                           -entry_date $entry_date \
                           -draft_p [ad_decode $publish_p 1 f t]
                      ]]
}

ad_proc -public blogger.editPost {
    appkey
    entry_id
    username
    password
    content
    publish_p
} {
    <strong>From Blogger API documentation:</strong>
    <p>
    blogger.editPost changes the contents of a given post. Optionally, will 
    publish the blog the post belongs to after changing the post. On success, 
    it returns a boolean true value. On error, it will return a fault with an 
    error message.
    </p>

    @param appkey (string): Ignored in OpenACS
    @param entry_id (string): Post's entry_id
    @param username (string): email or username for a user who has permission 
    to post to the blog.
    @param password (string): Password for said username/email
    @param content (string): Contents of the post
    @param publish_p (boolean): If true, the blog will be published 
    immediately after the post is made.

    @return returns 1 if success
} {
    set user_id [lars_blog_auth_for_xmlrpc \
                     -username $username \
                     -password $password]

    permission::require_permission -party_id $user_id \
        -object_id $entry_id \
        -privilege write

    lars_blog_entry_edit -entry_id $entry_id \
        -title " " \
        -content $content \
        -content_format "text/html" \
        -entry_date [clock format [clock seconds] -format %Y-%m-%d] \
        -draft_p [ad_decode $publish_p 1 f t]

    return [list -boolean 1]
}

ad_proc -public blogger.getUsersBlogs {
    appkey
    username
    password
} {
    <strong>From Blogger API documentation:</strong>
    <p>
    blogger.getUsersBlogs returns information about all the blogs a given
    user is a member of. Data is returned as an array of &lt;struct>'s
    containing the ID (blogid), name (blogName), and URL (url) of each
    blog.
    </p>

    <p>
    OpenACS Notes: Returns blogs on which user has 'create' privilege
    </p>

    @param appkey (string): Ignored in OpenACS
    @param username (string): email or username for a user who has permission 
    to post to the blog.
    @param password (string): Password for said username/email

    @return returns array of structs containing above information (one struct
            per blog)
} {
    set user_id [lars_blog_auth_for_xmlrpc \
                     -username $username \
                     -password $password]

    # find blogs on which this user has create permission

    set return_array [list]
    foreach package_id [lars_blog_list_user_blogs $user_id] {
        array unset struct
        set struct(url) [list -string \
                             [ad_url][lars_blog_public_package_url \
                                          -package_id $package_id]]
        set struct(blogid) [list -string $package_id]
        set struct(blogName) [list -string \
                                  [lars_blog_name -package_id $package_id]]
        
        lappend return_array [list -struct [array get struct]]
    }

    return [list -array $return_array]
}

ad_proc -public blogger.getUserInfo {
    appkey
    username
    password
} {
    <strong>From Blogger API documentation:</strong>
    <p>
    blogger.getUserInfo returns returns a struct containing user's userid, 
    firstname, lastname, nickname, email, and url.
    </p>

    <p>
    OpenACS Notes: I'm not going to fill nickname. I could use screename, but
    not sure what the semantics of that is supposed to be. Going to use
    the public 'about user' page for URL - is there a better choice?
    </p>

    @param appkey (string): Ignored in OpenACS
    @param username (string): email or username for a user who has permission 
    to post to the blog.
    @param password (string): Password for said username/email

    @return returns struct containing above information
} {
    set user_id [lars_blog_auth_for_xmlrpc \
                     -username $username \
                     -password $password]

    array set user_info [list]
    acs_user::get -user_id $user_id -array user_info
    
    array set struct []
    set struct(nickname) [list -string ""]
    set struct(userid) [list -string $user_id]
    set struct(url) [list -string \
                         [ad_url][acs_community_member_url -user_id $user_id]]
    set struct(email) [list -string $user_info(email)]
    set struct(lastname) [list -string $user_info(last_name)]
    set struct(firstname) [list -string $user_info(first_names)]

    return [list -struct [array get struct]]
}

# I don't see these next 3 methods in the Blogger 1.0 API, but 
# some tools implement them. Why aren't they documented anywhere?
# I found some documentation at 
# http://xmlrpc.free-conversant.com/docs/bloggerAPI#getPost

ad_proc -public blogger.getPost {
    appkey
    entry_id
    username
    password
} {
    <strong>From Blogger API documentation:</strong>
    <p>
    Not documented anywhere on blogger.com as of 2003-10-05.
    </p>

    <p>
    OpenACS Notes: The Blogger API has no place to store a title. This means
    that if you create an entry via the web interface and then getPost via
    the XML-RPC interface, you won't retrieve the title that you entered. Each
    client tool that I've tested handles this fault in the Blogger API 
    differently, so there's no easy way to consistently handle all clients.
    NetNewsWire disables the title field in its UI, which I think is the
    correct thing to do.
    </p>

    @param appkey (string): Ignored in OpenACS
    @param entry_id (string): Post's entry_id
    @param username (string): email or username for a user who has permission 
    to post to the blog.
    @param password (string): Password for said username/email

    @return struct containing values content ( message body ), userId, 
    postId and dateCreated.
} {
    set user_id [lars_blog_auth_for_xmlrpc \
                     -username $username \
                     -password $password]

    permission::require_permission -party_id $user_id \
        -object_id $entry_id \
        -privilege read

    array set e [list]

    if { ![catch {lars_blogger::entry::get -entry_id $entry_id -array e} errmsg] } {
        # put the date in readable format
        set posted_date "$e(entry_date) $e(posted_time_pretty)"

        array set struct [list]
        # note: Blogger has no space for title, so we ignore title
        set struct(content) [list -string "$e(content)"]
        set struct(userid) [list -string $user_id]
        set struct(postid) [list -string $entry_id]
        set struct(dateCreated) [list -date $posted_date]
    }

    return [list -struct [array get struct]]
}

ad_proc -public blogger.getRecentPosts {
    appkey
    package_id
    username
    password
    numberOfPosts
} {
    <strong>From Blogger API documentation:</strong>
    <p>
    Not documented anywhere on blogger.com as of 2003-10-05.
    </p>

    @param appkey (string): Ignored in OpenACS
    @param package_id (string): Blog's package_id
    @param username (string): email or username for a user who has permission 
    to post to the blog.
    @param password (string): Password for said username/email
    @param numberOfPosts (integer): Number of posts to retrieve.

    @return an array of structs containing the latest n posts to a given
    blog, newest first. Each post struct includes: dateCreated (when post 
    was made), userid (who made the post), postid, and content.
} {
    set user_id [lars_blog_auth_for_xmlrpc \
                     -username $username \
                     -password $password]

    permission::require_permission -party_id $user_id \
        -object_id $package_id \
        -privilege read

    set return_array [list]

    db_foreach get_n_entries {} {
        # put the date in readable format
        set posted_date "${entry_date} ${posted_time_pretty}"
        array unset struct
        set struct(content) [list -string $content]
        set struct(postid) [list -string $entry_id]
        set struct(userid) [list -string $user_id]
        set struct(dateCreated) [list -date $posted_date]
        
        lappend return_array [list -struct [array get struct]]
    }

    return [list -array $return_array]
}

ad_proc -public blogger.deletePost {
    appkey
    entry_id
    username
    password
    publish_p 
} {
    <strong>From Blogger API documentation:</strong>
    <p>
    Not documented anywhere on blogger.com as of 2003-10-05.
    </p>

    @param appkey (string): Ignored in OpenACS
    @param entry_id (string): Post's entry_id
    @param username (string): email or username for a user who has permission 
    to post to the blog.
    @param password (string): Password for said username/email
    @param publish_p (boolean): Ignored.

    @return boolean true if successful deletion.
} {
    set user_id [lars_blog_auth_for_xmlrpc \
                     -username $username \
                     -password $password]

    lars_blogger::entry::delete -entry_id $entry_id

    return [list -boolean 1]
}


# vinodk - The following methods are unimplemented in OpenACS

#
# blogger.getTemplate: Returns the main or archive index template of a
# given blog.
#
# blogger.setTemplate: Edits the main or archive index template of a given
# blog.
