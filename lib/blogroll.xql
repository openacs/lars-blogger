<?xml version="1.0"?>

<queryset>
    <fullquery name="blogroll_select">
        <querytext>
        select
            name, url
        from
            weblogger_blogroll_entries
        where
            package_id = :package_id
        order by
            sort_order, name asc
        </querytext>
    </fullquery>
</queryset>
