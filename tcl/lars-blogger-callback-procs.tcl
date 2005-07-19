ad_library {

     Library for lars blogger's callbacks implementations

     @author Enrique Catalan (quio@galileo.edu)
     @creation-date July 19, 2005
     @cvs-id $Id$
}

ad_proc -callback merge::MergeShowUserInfo -impl lars_blogger {
    -user_id:required
} {
    Show the items of user_id
} {
    set msg "Lars_blogger items of $user_id"
    set result [list $msg]

    set channels [db_list_of_lists sel_channels { *SQL* }]
    lappend result $channels
    
    return $result
}

ad_proc -callback merge::MergePackageUser -impl lars_blogger {
    -from_user_id:required
    -to_user_id:required
} {
    Merge the entries of two users.

    The from_user_id is the user_id of the user
    that will be deleted and all the entries
    of this user will be mapped to the to_user_id.
    
} {
    set msg "Merging lars_blogger"
    ns_log Notice $msg
    set result [list $msg]

    db_dml upd_channels { *SQL* }
    
    lappend result "Merge of lars_blogger is done"
    
    return $result
}