ad_library {
    Notification procs for lars-blogger.

    @author Lars Pind (lars@collaboraid.biz)
    @creation-date 2003-06-29
    @cvs-id $Id$
}

namespace eval lars_blogger::notification {}


ad_proc -public lars_blogger::notification::get_url {
    object_id
} {
    Get the URL of a blogger entry.
} {
    # LARS:
    # Not implemented. Sorry.
    # At least this is better than a hard error.
    return {}
}

ad_proc -public lars_blogger::notification::process_reply {
    reply_id
} {
    Process the reply to a blog posting: Post the reply as a comment.
    Not implemented, sorry.
} {
    # LARS:
    # Not implemented. Sorry.
    # At least this is better than a hard error.

    # Return successful_p = "f"
    # It doesn't look like notifications does anything with this, though :(
    return "f"
}
    
