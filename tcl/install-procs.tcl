ad_library {
    install callbacks
}

namespace eval lars_blogger::install {}

ad_proc -public lars_blogger::install::package_instantiate { -package_id } {
    Procedures to run on package instantiation
} {

    lars_blogger::install::grant_gc_create -package_id $package_id

}

ad_proc -public lars_blogger::install::grant_gc_create { -package_id } {
    sets up default anonymous comments
} {
    set party_id [acs_magic_object "unregistered_visitor"]
    permission::grant -object_id $package_id \
	              -party_id $party_id \
	              -privilege "general_comments_create"
}
