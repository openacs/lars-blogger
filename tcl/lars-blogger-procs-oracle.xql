<?xml version="1.0"?>

<queryset>
    <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

   <fullquery name="lars_blog_setup_feed.create_instance_channel">
        <querytext>
                begin
                    :1 := weblogger_channel.new (
                        null,
                        :package_id,
                        NULL,
                        :creation_user,
                        :creation_ip
                    );
                end;
        </querytext>
    </fullquery>

   <fullquery name="lars_blog_setup_feed.create_user_channel">
        <querytext>
                begin
                    :1 := weblogger_channel.new (
                        null,
                        :package_id,
                        :creation_user,
                        :creation_user,
                        :creation_ip
                    );
                end;
         </querytext>
    </fullquery>

    <fullquery name="lars_blog_setup_feed.create_subscr">
        <querytext>
            begin
                :1 := rss_gen_subscr.new (
                    null,                                      -- subscr_id
                    acs_sc_impl.get_id('RssGenerationSubscriber','pinds_blog_entries'),
                                                               -- impl_id
                    :summary_context_id,                       -- summary_context_id
                    :timeout,                                  -- timeout
                    null,                                      -- lastbuild
                    'rss_gen_subscr',                          -- object_type
                    sysdate,                                   -- creation_date
                    :creation_user,                            -- creation_user
                    :creation_ip,                              -- creation_ip
                    :package_id                                -- context_id
                );
            end;
        </querytext>
    </fullquery>

</queryset>
