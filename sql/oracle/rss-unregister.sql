--
-- rss-unregister.sql
--
-- Unregister the RSS Service contract
--
-- @author Lars Pind
-- @author Vinod Kurup (vinod@kurup.com) Oracle Port
--
-- @cvs-id $Id$
--

begin

    for channel in (select channel_id from weblogger_channels) loop
        weblogger_channel.del(channel.channel_id);
    end loop;

	acs_sc_impl.del(
		impl_contract_name => 'RssGenerationSubscriber',
		impl_name => 'pinds_blog_entries'
	);

end;
/
show errors
