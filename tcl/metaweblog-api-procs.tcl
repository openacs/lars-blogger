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

    if { ![exists_and_not_null content(title)] } {
        set content(title) " "
    }
    
    if { ![exists_and_not_null content(description)] } {
        set content(description) " "
    }
    
    # OpenACS time format YYYY-MM-DD
    set fmt "%Y-%m-%d"

    # hopefully pubDate is in a readable format
    if { [catch {set pubDate [clock format [clock scan $content(pubDate)] -format $fmt]}] } {
        set pubDate [clock format [clock seconds] -format $fmt]
    }
    
    # ignore 'enclosure' for now

    if { [exists_and_not_null content(categories)] } {
	# Only looking at the first category
	set category_name [lindex $content(categories) 0]
	set category_id [db_string select_category_id { 
	    select category_id
	    from   pinds_blog_categories 
	    where  package_id = :package_id 
	    and    name = :category_name 
	}]
    } else {
	set category_id {}
    }
	
    
    return [list -string [lars_blog_entry_add -entry_id $entry_id \
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

    if { ![exists_and_not_null content(title)] } {
        set content(title) " "
    }
    
    if { ![exists_and_not_null content(description)] } {
        set content(description) " "
    }
    
    # OpenACS time format YYYY-MM-DD
    set fmt "%Y-%m-%d"

    # hopefully pubDate is in a readable format
    if { [catch {set pubDate [clock format [clock scan $content(pubDate)] -format $fmt]}] } {
        set pubDate [clock format [clock seconds] -format $fmt]
    }
    
    # ignore 'category', 'enclosure' for now
    
    lars_blog_entry_edit -entry_id $entry_id \
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

    set category [value_if_exists content(category_name)]

    # get the package_id from the entry_id
    set package_id [db_string package_id {}]

    # get the permanent URL of this entry - use this as
    # the link, guid and comments url
    set perm_url "[ad_url][lars_blog_public_package_url -package_id $package_id]one-entry?[export_vars { entry_id }]"

    # put the date in readable format
    set posted_date "$content(entry_date) $content(posted_time_pretty)"

    return [list -struct \
                [list \
                     title [list -string $content(title)] \
                     link [list -string $perm_url] \
                     postid [list -string $entry_id] \
                     userid [list -string $user_id] \
                     description [list -string $content(content)] \
                     category [list -string $category] \
                     comments [list -string $perm_url] \
                     guid [list -string $perm_url] \
                     pubDate [list -date $posted_date] \
                     dateCreated [list -date $posted_date] \
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
        
        # put the date in readable format
        set posted_date "${entry_date} ${posted_time_pretty}"

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
                             pubDate [list -date $posted_date] \
                             dateCreated [list -date $posted_date] \
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
