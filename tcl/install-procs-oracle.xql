<?xml version="1.0"?>

<queryset>
    <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

    <fullquery name="lars_blogger::install::package_uninstantiate.clear_content">
        <querytext>

        begin
            -- delete weblogger_channels
            for channel in (select channel_id from weblogger_channels
                              where package_id = :package_id) loop
                weblogger_channel.del(channel.channel_id);
            end loop;

            -- delete weblog entries
            for entry in (select entry_id from pinds_blog_entries
                            where package_id = :package_id) loop
                pinds_blog_entry.del(entry.entry_id);
            end loop;

            return 0;
        end;

        </querytext>
    </fullquery>

</queryset>
