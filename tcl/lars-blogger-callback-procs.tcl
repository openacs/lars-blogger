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

#Callbacks for application-track

ad_proc -callback application-track::getApplicationName -impl weblogger {} { 
        callback implementation 
    } {
        return "weblogger"
    }    
    
ad_proc -callback application-track::getGeneralInfo -impl weblogger {} { 
        callback implementation 
    } {
	db_1row my_query {
    		select count(1) as result
			from pinds_blog_entries w,  dotlrn_communities com
		    	where com.community_id=:comm_id
			and apm_package__parent_id(w.package_id) = com.package_id	
	}
	
	return "$result"
    }
ad_proc -callback application-track::getSpecificInfo -impl weblogger {} { 
        callback implementation 
    } {
   	
	upvar $query_name my_query
	upvar $elements_name my_elements

	set my_query {
		select count(c.comment_id) as result
			from pinds_blog_entries w,  dotlrn_communities com, general_comments c
		    	where com.community_id=:class_instance_id
			and apm_package__parent_id(w.package_id) = com.package_id
			and c.object_id=w.entry_id
			group by w.entry_id
	}
		
	set my_elements {
		comments {
	            label "Comments per weblogger"
	            display_col result	                        
	 	    html {align center}	 	                
	        }
	        
	}

        return "OK"
    }