<?xml version="1.0"?>

<queryset>
    <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

    <fullquery name="lars_blog_entry_add.entry_add">
        <querytext>
                        begin
                                :1 := pinds_blog_entry.new (
                        entry_id => :entry_id,
                        package_id => :package_id,
                        title => :title,
                        title_url => :title_url,
                        content => :content,
                        content_format => :content_format,
                        entry_date => to_date(:entry_date, 'YYYY-MM-DD'),
                        draft_p => :draft_p,
                        creation_user => :creation_user,
                        creation_ip => :creation_ip
                        );
                        end;
        </querytext>
    </fullquery>

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
