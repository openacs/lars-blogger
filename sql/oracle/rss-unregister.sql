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

	acs_sc_impl.del(
		impl_contract_name => 'RssGenerationSubscriber',
		impl_name => 'pinds_blog_entries'
	);

end;
/
show errors
