<?xml version="1.0"?>

<queryset>
    <rdbms><type>postgresql</type><version>7.1</version></rdbms>

    <fullquery name="lars_blogger::install::package_uninstantiate.remove_ping_urls">
        <querytext>
        delete from weblogger_ping_urls
            where package_id = :package_id
        </querytext>
    </fullquery>

    <fullquery name="lars_blogger::install::setup_ping_urls.setup_ping_urls">
        <querytext>
        insert into weblogger_ping_urls (
            package_id,
            ping_url
        ) values (
            :package_id,
            :default_ping_url
        )
        </querytext>
    </fullquery>
    
    <fullquery name="lars_blogger::install::package_uninstantiate.clear_content">
        <querytext>

        declare
            channel_rec         record;
            entry_rec           record;
        begin
            -- delete weblogger_channels
            for channel_rec in select channel_id from weblogger_channels
                                 where package_id = :package_id loop
                perform weblogger_channel__delete(channel_rec.channel_id);
            end loop;

            -- delete weblog entries
            for entry_rec in select entry_id from pinds_blog_entries
                                where package_id = :package_id loop
                perform pinds_blog_entry__delete(entry_rec.entry_id);
            end loop;

            return 0;
        end;

        </querytext>
    </fullquery>

</queryset>
