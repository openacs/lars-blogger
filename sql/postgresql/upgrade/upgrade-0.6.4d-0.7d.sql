--
-- upgrade-0.6.4d-0.7d.sql
-- 
-- @author Vinod Kurup (vinod@kurup.com)
-- 
-- @cvs-id $Id$
--

-- the only change is in the name of a proc that we send to 
-- asc_sc_impl_alias. So, we just delete the old alias
-- and create a new one with the proper proc name (lars_blog...)

select acs_sc_impl_alias__delete(
    'RssGenerationSubscriber',			-- impl_contract_name
    'pinds_blog_entries',				-- impl_name
    'lastUpdated',						-- impl_operation_name
);


select acs_sc_impl_alias__new(
       'RssGenerationSubscriber',               -- impl_contract_name
       'pinds_blog_entries',                    -- impl_name
       'lastUpdated',                           -- impl_operation_name
       'lars_blog__rss_lastUpdated',            -- impl_alias
       'TCL'                                    -- impl_pl
);

