<?xml version="1.0"?>

<queryset>
    <fullquery name="links_select">
        <querytext>
        select
                link_id,
                name,
                url
        from
                weblogger_blogroll_entries
        where
                package_id = :package_id
        order by
                sort_order, name asc
        </querytext>
    </fullquery>
</queryset>
