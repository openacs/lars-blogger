--
-- rss-unregister.sql
-- 
-- @author Lars Pind
-- 
-- @cvs-id $Id$
--

-- need to delete our channels and rss feeds or else
-- the SC can't be dropped

create or replace function inline_0() 
returns integer as '
declare
    channel_rec         record;
begin
    -- delete weblogger_channels
    for channel_rec in select channel_id from weblogger_channels loop
        perform weblogger_channel__delete(channel_rec.channel_id);
    end loop;

    return 0;
end;' language 'plpgsql';

select inline_0();
drop function inline_0();

select acs_sc_impl__delete(
  'RssGenerationSubscriber',        -- impl_contract_name
  'pinds_blog_entries'              -- impl_name
);

