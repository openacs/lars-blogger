--
-- rss-register.sql
-- 
-- @author Lars Pind
-- 
-- @cvs-id $Id$
--

create function inline_0() returns integer as '
declare
        impl_id integer;
        v_foo   integer;
begin
    -- the notification type impl
    impl_id := acs_sc_impl__new(
        ''RssGenerationSubscriber'',               -- impl_contract_name
        ''pinds_blog_entries'',                    -- impl_name
        ''lars-blogger''                           -- impl_owner_name
    );  

    v_foo := acs_sc_impl_alias__new(
        ''RssGenerationSubscriber'',               -- impl_contract_name
        ''pinds_blog_entries'',                    -- impl_name
        ''datasource'',                            -- impl_operation_name
        ''lars_blog__rss_datasource'',             -- impl_alias
        ''TCL''                                    -- impl_pl
    );

    v_foo := acs_sc_impl_alias__new(
        ''RssGenerationSubscriber'',               -- impl_contract_name
        ''pinds_blog_entries'',                    -- impl_name
        ''lastUpdated'',                           -- impl_operation_name
        ''lars_blog__rss_lastUpdated'',            -- impl_alias
        ''TCL''                                    -- impl_pl
    );

    PERFORM acs_sc_binding__new (
        ''RssGenerationSubscriber'',
        ''pinds_blog_entries''
    );

    return (0);
end;
' language 'plpgsql';

select inline_0();
drop function inline_0();



