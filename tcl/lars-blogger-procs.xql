<?xml version="1.0"?>

<queryset>

    <fullquery name="lars_blog_entry_add.exists_instance_feed_p">
        <querytext>
            select count(*)
            from   rss_gen_subscrs s,
                   acs_sc_impls i, 
                   weblogger_channels w
            where  s.summary_context_id = w.channel_id
            and    w.package_id = :package_id
            and    w.user_id = '0'
            and    s.impl_id = i.impl_id
            and    i.impl_name = 'pinds_blog_entries'
            and    i.impl_owner_name = 'lars-blogger'
        </querytext>
    </fullquery>

    <fullquery name="lars_blog_entry_add.exists_user_feed_p">
        <querytext>
            select count(*)
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

    <fullquery name="lars_blog_entry_add.create_subscr">
        <querytext>
            select rss_gen_subscr__new (
                null,                                      -- subscr_id
                acs_sc_impl__get_id('RssGenerationSubscriber','pinds_blog_entries'),
                                                           -- impl_id
                :summary_context_id,                       -- summary_context_id
                :timeout,                                  -- timeout
                null,                                      -- lastbuild
                'rss_gen_subscr',                          -- object_type
                now(),                                     -- creation_date
                :creation_user,                            -- creation_user
                :creation_ip,                              -- creation_ip
                :package_id                                -- context_id
            )
        </querytext>
    </fullquery>

    <fullquery name="lars_blog_entry_add.update_subscr">
        <querytext>
            update rss_gen_subscrs
            set    channel_title = :channel_title,
                   channel_link = :channel_link
            where  subscr_id = :subscr_id
        </querytext>
    </fullquery>

    <fullquery name="lars_blog_entry_add.screen_name">
        <querytext>
            select screen_name from users where user_id = :creation_user
        </querytext>
    </fullquery>

</queryset>
