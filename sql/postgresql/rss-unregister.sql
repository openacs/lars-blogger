--
-- rss-unregister.sql
-- 
-- @author Lars Pind
-- 
-- @cvs-id $Id$
--

select acs_sc_impl__delete(
  'RssGenerationSubscriber',        -- impl_contract_name
  'pinds_blog_entries'              -- impl_name
);

