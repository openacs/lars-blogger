--
-- Upgrade script
-- 
-- Binds the service contract if it isn't already bound
--
-- @author Lars Pind (lars@pinds.com)
-- @creation-date 2003-01-30
--

select acs_sc_binding__new ('RssGenerationSubscriber', 'pinds_blog_entries')
from   acs_sc_impls i
where  i.impl_name = 'pinds_blog_entries'
and    i.impl_contract_name = 'RssGenerationSubscriber'
and    not exists (select 1 from acs_sc_bindings b where b.impl_id = i.impl_id);

