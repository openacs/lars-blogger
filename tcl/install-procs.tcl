ad_library {
    install callbacks
}

namespace eval lars_blogger::install {}

ad_proc -public lars_blogger::install::package_instantiate { -package_id } {
    Procedures to run on package instantiation
} {

    lars_blogger::install::grant_gc_create -package_id $package_id
    lars_blogger::install::setup_ping_urls -package_id $package_id
}

ad_proc -public lars_blogger::install::setup_ping_urls { -package_id } {
    Sets up the default ping URL with the weblogs.com ping URL. If it
    already exists, we don't care.
    
    @author Guan Yang
    @creation-date 2003-12-13
} {
    set default_ping_url [ad_parameter -package_id $package_id weblogs_ping_url]
    catch { db_dml setup_ping_urls "" }
}

ad_proc -public lars_blogger::install::grant_gc_create { -package_id } {
    sets up default anonymous comments
} {
    set party_id [acs_magic_object "unregistered_visitor"]
    permission::grant -object_id $package_id \
	              -party_id $party_id \
	              -privilege "general_comments_create"
}

ad_proc -private lars_blogger::install::package_uninstantiate {
    {-package_id:required}
} {
    Package un-instantiation callback proc. Permanently delete all the 
    content associated with a blog. Deletes all entries, comments and rss 
    feeds.

    @author Vinod Kurup
} {
    db_dml remove_ping_urls ""
    db_exec_plsql clear_content {}
}
