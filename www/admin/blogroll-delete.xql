<?xml version="1.0"?>

<queryset>
    <fullquery name="link_select">
        <querytext>
        select
            package_id
        from
            weblogger_blogroll_entries
        where
            link_id = :link_id
        </querytext>
    </fullquery>
</queryset>
