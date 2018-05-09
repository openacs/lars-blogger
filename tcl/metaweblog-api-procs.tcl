# /packages/lars-blogger/tcl/metaweblog-api-procs.tcl
ad_library {
    Support the MetaWeblog API
    http://www.xmlrpc.com/metaWeblogApi

    @author Vinod Kurup [vinod@kurup.com]
    @creation-date Sun Oct  5 19:52:39 2003
    @cvs-id $Id$
}

ad_proc -public metaWeblog.newPost {
    package_id
    username
    password
    content_array
    publish_p
} {
    Create a new blog entry.
    
    <p>
    The most important piece is <code>content</code> - a XML-RPC struct. Its 
    members can be any element of the &lt;item> tag of the 
    <a href="http://blogs.law.harvard.edu/tech/rss\#hrelementsOfLtitemgt">RSS 
    2.0 spec </a>. 
    As of right now, these include: title, link, description, author, 
    category, comments, enclosure, guid, pubDate, and source. All are optional
    except that either title or description must be provided. There is an
    additional element which is not part of the RSS 2.0 spec - a boolean
    named flNotOnHomePage, which, if true, specifies to post only to the
    categories page, not to the home page. I have not yet implemented this
    on OpenACS. Finally, since RSS 2.0 supports XML namespaces, 
    <code>content</code> may also contain these other elements. If present,
    these will be supplied in a substruct whose name is the namespace's URL
    and whose subelements are the values from the namespace. This confuses me,
    so it's not yet implemented. The spec says that the server should ignore
    any elements it doesn't understand, so I'm covered. (grin)
    </p>

    <p>
    <code>content</code> is supplied as an array. Most of its elements are 
    simple key-value pairs. The enclosure element is more complex - will 
    ignore for now. Multiple 'category' elements may be present.
    </p>
    
    @param package_id The blog's package_id
    @param username We'll determine if this is a username or an email
    @param password password
    @param content struct containing blog content and metadata
    @param publish_p set to true if entry is to be published, false for draft

    @return entry_id of the new post, as a string
    @author Vinod Kurup <vinod@kurup.com>
} {
    array set content $content_array

    set user_id [lars_blog_auth_for_xmlrpc \
                     -username $username \
                     -password $password]

    permission::require_permission -party_id $user_id \
        -object_id $package_id \
        -privilege create

    set entry_id [db_nextval t_acs_object_id_seq]

    if { ![info exists content(title)] || $content(title) eq "" } {
        set content(title) " "
    }
    
    if { ![info exists content(description)] || $content(description) eq "" } {
        set content(description) " "
    }
    
    # OpenACS time format YYYY-MM-DD
    set fmt "%Y-%m-%d %H:%M:%S"

    # hopefully pubDate is in a readable format
    if { [catch {set pubDate [clock format [clock scan $content(pubDate)] -format $fmt]}] } {
        set pubDate [clock format [clock seconds] -format $fmt]
    }
    
    if { [info exists content(categories)] && $content(categories) ne "" } {
	# Only looking at the first category
	set category_id [lars_blogger::category::get_id_by_name \
			     -package_id $package_id \
			     -name [lindex $content(categories) 0]]
    } else {
	set category_id {}
    }
	
    # ignore 'enclosure' for now

    return [list -string [lars_blogger::entry::new \
			      -entry_id $entry_id \
			      -package_id $package_id \
			      -title $content(title) \
			      -content $content(description) \
			      -content_format "text/html" \
			      -entry_date $pubDate \
			      -category_id $category_id \
			      -draft_p [ad_decode $publish_p 1 f t]
			 ]]
}

ad_proc -public metaWeblog.editPost {
    entry_id
    username
    password
    content_array
    publish_p
} {
    Edit blog entry.
    
    @see metaWeblog.newPost
    @param entry_id entry to be edited
    @param username We'll determine if this is a username or an email
    @param password
    @param content XML-RPC struct containing blog content and metadata
    @param publish_p true for publish, false for draft

    @return boolean 1 if success
    @author Vinod Kurup <vinod@kurup.com>
} {
    array set content $content_array

    set user_id [lars_blog_auth_for_xmlrpc \
                     -username $username \
                     -password $password]

    permission::require_permission -party_id $user_id \
        -object_id $entry_id \
        -privilege write

    if { ![info exists content(title)] || $content(title) eq "" } {
        set content(title) " "
    }
    
    if { ![info exists content(description)] || $content(description) eq "" } {
        set content(description) " "
    }
    
    # OpenACS time format YYYY-MM-DD
    set fmt "%Y-%m-%d %H:%M:%S"

    # hopefully pubDate is in a readable format
    if { [catch {set pubDate [clock format [clock scan $content(pubDate)] -format $fmt]}] } {
        set pubDate [clock format [clock seconds] -format $fmt]
    }
    
    if { [info exists content(categories)] && $content(categories) ne "" } {
	# Only looking at the first category
	set category_id [lars_blogger::category::get_id_by_name \
			     -package_id $package_id \
			     -name [lindex $content(categories) 0]]
    } else {
	set category_id {}
    }
	
    # ignore 'enclosure' for now
    
    lars_blogger::entry::edit \
	-entry_id $entry_id \
        -title $content(title) \
        -content $content(description) \
        -content_format "text/html" \
        -entry_date $pubDate \
        -draft_p [ad_decode $publish_p 1 f t]
    
    return [list -boolean 1]
}

ad_proc -public metaWeblog.getPost {
    entry_id
    username
    password
} {
    Get a blog entry.
    
    @param entry_id Entry to get
    @param username We'll determine if this is a username or an email
    @param password

    @return struct containing post and metadata
    @author Vinod Kurup <vinod@kurup.com>
} {
    set user_id [lars_blog_auth_for_xmlrpc \
                     -username $username \
                     -password $password]

    permission::require_permission -party_id $user_id \
        -object_id $entry_id \
        -privilege read

    array set content [list]
    lars_blogger::entry::get -entry_id $entry_id -array content

    return [list -struct \
                [list \
                     title [list -string $content(title)] \
                     link [list -string $content(permalink_url)] \
                     postid [list -string $entry_id] \
                     userid [list -string $user_id] \
                     description [list -string $content(content)] \
                     category [list -string $content(category_name)] \
                     comments [list -string $content(permalink_url)] \
                     guid [list -string $content(permalink_url)] \
                     pubDate [list -date $content(entry_date_ansi)] \
                     dateCreated [list -date $content(entry_date_ansi)] \
                    ]]
}

ad_proc -public metaWeblog.getRecentPosts {
    package_id
    username
    password
    num_posts
} {
    Get recent posts.
    
    @param package_id 
    @param username We'll determine if this is a username or an email
    @param password
    @param num_posts number of posts requested

    @return array of structs
    @author Vinod Kurup <vinod@kurup.com>
} {
    set user_id [lars_blog_auth_for_xmlrpc \
                     -username $username \
                     -password $password]

    permission::require_permission -party_id $user_id \
        -object_id $package_id \
        -privilege read

    set blog_url "[ad_url][lars_blog_public_package_url -package_id $package_id]one-entry?"
    set result ""

    db_foreach get_n_entries {} {
        set perm_url "${blog_url}[export_vars { entry_id }]"
        
        set struct [list -struct \
                        [list \
                             title [list -string $title] \
                             link [list -string $perm_url] \
                             postid [list -string $entry_id] \
                             userid [list -string $user_id] \
                             description [list -string $content] \
                             category [list -string $category] \
                             comments [list -string $perm_url] \
                             guid [list -string $perm_url] \
                             pubDate [list -date $entry_date_ansi] \
                             dateCreated [list -date $entry_date_ansi] \
                            ]]
        
        lappend result $struct
    }

    return [list -array $result]
}

# unimplemented so far
# metaWeblog.newMediaObject 


ad_proc -public metaWeblog.getCategories {
    package_id
    username
    password
} {
    Get categories.
    
    @param package_id 
    @param username We'll determine if this is a username or an email
    @param password

    @return array of structs
    @author Lars Pind (lars@collaboraid.biz)
} {
    set user_id [lars_blog_auth_for_xmlrpc \
                     -username $username \
                     -password $password]

    permission::require_permission -party_id $user_id \
        -object_id $package_id \
        -privilege read

    set blog_url "[ad_url][lars_blog_public_package_url -package_id $package_id]"
    set result ""

    db_foreach select_categories {} {
        set html_url "${blog_url}cat/$short_name/"
        
        set struct [list -struct \
                        [list \
                             description [list -string $name] \
                             htmlUrl [list -string $html_url] \
                             rssUrl [list -string {}] \
			    ]]
        
        lappend result $struct
    }

    return [list -array $result]
}
