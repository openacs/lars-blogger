<?xml version="1.0"?>

<queryset>
    <fullquery name="lars_blogger::technorati::populate_cache.flush_cache">
        <querytext>
        delete from weblogger_technorati_cache
        where package_id = :package_id
        </querytext>
    </fullquery>
    
    <fullquery name="lars_blogger::technorati::populate_cache.cache_insert">
        <querytext>
        insert into weblogger_technorati_cache (
            package_id,
            name,
            url
        ) values (
            :package_id,
            :name,
            :url
        )
        </querytext>
    </fullquery>
    
    <fullquery name="lars_blogger::technorati::scheduled_job.blogger_instances">
        <querytext>
        select package_id
        from apm_packages
        where package_key = 'lars-blogger'
        </querytext>
    </fullquery>
</queryset>
