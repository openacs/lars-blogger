<?xml version="1.0"?>

<queryset>

    <fullquery name="package_name">
        <querytext>
			select instance_name from apm_packages 
			where package_id = :package_id
        </querytext>
    </fullquery>

    <fullquery name="rss_feed_p">
        <querytext>
            select count(*)
            from   rss_gen_subscrs s,
                   acs_sc_impls i, weblogger_channels w
            where  w.package_id = :package_id
            and    s.summary_context_id = w.channel_id
            and    s.impl_id = i.impl_id
            and    i.impl_name = 'pinds_blog_entries'
            and    i.impl_owner_name = 'lars-blogger'
        </querytext>
    </fullquery>

</queryset>
