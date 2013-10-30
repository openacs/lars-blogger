ad_page_contract {
    Move a blogroll entry up or down.
    
    @author Guan Yang (guan@unicast.org)
    @creation-date 2003-12-14
} {
    direction:notnull
    link_id:naturalnum,notnull
}

set package_id [ad_conn package_id]

# Check that direction is up or down, and that package_id is correct
if { ($direction ne "up" && $direction ne "down" )
  || [db_string entry_package_id "" -default 0] ne $package_id } {
    ad_returnredirect "blogroll"
    ad_script_abort
}

db_transaction {
    # First we get the current order
    
    set current_order [db_list current_order ""]
    
    # Go away if the current link_id is not in there
    if {$link_id ni $current_order} {
        db_abort_transaction
        ad_returnredirect "blogroll"
        ad_script_abort
    }
    
    # Current position
    set current_position [lsearch -exact $current_order $link_id]
    set last_position [expr {[llength $current_order]-1}]
    
    # Calculate new position
    if { $direction eq "up" && $current_position != 0 } {
        set new_position [expr {$current_position-1}]
    } elseif { $direction eq "down" && $current_position != $last_position } {
        set new_position [expr {$current_position+1}]
    }
    
    if { [info exists new_position] } {
        # Put displaced entry in current position
        set displaced_entry [lindex $current_order $new_position]
        
        if { $direction eq "down"} {
            set new_order [lreplace $current_order $current_position $new_position $displaced_entry $link_id]
        } else {
            set new_order [lreplace $current_order $new_position $current_position $link_id $displaced_entry] 
        }
        
        set i 0
        foreach entry $new_order {
            db_dml set_order ""
            incr i
        }
    }
}

ad_returnredirect "blogroll"
