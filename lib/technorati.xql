<?xml version="1.0"?>

<queryset>
    <fullquery name="cache_select">
        <querytext>
        select name, url
        from weblogger_technorati_cache
        where package_id = :package_id
        </querytext>
    </fullquery>
</queryset>

