<?xml version="1.0"?>

<queryset>

    <fullquery name="create_subscr">
        <querytext>
            select rss_gen_subscr__new (
                null,                                      -- subscr_id
                acs_sc_impl__get_id('RssGenerationSubscriber','pinds_blog_entries'),
                                                           -- impl_id
                :package_id,                               -- summary_context_id
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

    <fullquery name="update_subscr">
        <querytext>
            update rss_gen_subscrs
            set    channel_title = :channel_title,
                   channel_link = :channel_link
            where  subscr_id = :subscr_id
        </querytext>
    </fullquery>

</queryset>
