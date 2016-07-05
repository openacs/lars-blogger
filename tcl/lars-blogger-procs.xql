<?xml version="1.0"?>

<queryset>

    <fullquery name="lars_blog_setup_feed.select_instance_channel">
        <querytext>
            select w.channel_id
            from   weblogger_channels w
            where  w.package_id = :package_id
            and    w.user_id is null
        </querytext>
    </fullquery>

    <fullquery name="lars_blog_setup_feed.instance_feed_subscr_id">
        <querytext>
            select subscr_id
            from   rss_gen_subscrs s,
                   acs_sc_impls i, 
                   weblogger_channels w
            where  s.summary_context_id = w.channel_id
            and    w.package_id = :package_id
            and    w.user_id is null
            and    s.impl_id = i.impl_id
            and    i.impl_name = 'pinds_blog_entries'
            and    i.impl_owner_name = 'lars-blogger'
        </querytext>
    </fullquery>

    <fullquery name="lars_blog_setup_feed.select_user_channel">
        <querytext>
            select w.channel_id
            from   weblogger_channels w
            where  w.package_id = :package_id
            and    w.user_id = :creation_user
        </querytext>
    </fullquery>

    <fullquery name="lars_blog_setup_feed.user_feed_subscr_id">
        <querytext>
            select subscr_id
            from   rss_gen_subscrs s,
                   acs_sc_impls i,
                   weblogger_channels w
            where  s.summary_context_id = w.channel_id
            and    w.user_id = :creation_user
            and    w.package_id = :package_id
            and    s.impl_id = i.impl_id
            and    i.impl_name = 'pinds_blog_entries'
            and    i.impl_owner_name = 'lars-blogger'
        </querytext>
    </fullquery>

    <fullquery name="lars_blog_setup_feed.update_subscr">
        <querytext>
            update rss_gen_subscrs
            set    channel_title = :channel_title,
                   channel_link = :channel_link
            where  subscr_id = :subscr_id
        </querytext>
    </fullquery>

    <fullquery name="lars_blog_setup_feed.screen_name">
        <querytext>
            select screen_name from users where user_id = :creation_user
        </querytext>
    </fullquery>

    <fullquery name="lars_blogger::count.entry_count">
        <querytext>
            select count(*) 
              from pinds_blog_entries 
             where package_id = :package_id 
               and draft_p = 'f'
        </querytext>
    </fullquery>

</queryset>
