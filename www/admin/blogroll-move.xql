<?xml version="1.0"?>

<queryset>
    <fullquery name="entry_package_id">
        <querytext>
        select package_id
        from weblogger_blogroll_entries
        where link_id = :link_id
        </querytext>
    </fullquery>
    
    <fullquery name="current_order">
        <querytext>
        select link_id
        from weblogger_blogroll_entries
        where package_id = :package_id
        order by sort_order, name asc
        </querytext>
    </fullquery>
    
    <fullquery name="set_order">
        <querytext>
        update weblogger_blogroll_entries
        set sort_order = :i
        where link_id = :entry
        </querytext>
    </fullquery>
</queryset>
