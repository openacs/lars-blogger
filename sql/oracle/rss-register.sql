--
-- rss-register.sql
-- 
-- @author Lars Pind
-- 
-- @cvs-id $Id$
--

declare
    foo integer;
begin

    foo := acs_sc_impl.new(
        impl_contract_name => 'RssGenerationSubscriber',
        impl_name => 'pinds_blog_entries',
        impl_owner_name => 'lars-blogger'
    );

    foo := acs_sc_impl_alias.new(
        impl_contract_name => 'RssGenerationSubscriber',
        impl_name => 'pinds_blog_entries',
        impl_operation_name => 'datasource',
        impl_alias => 'lars_blog__rss_datasource',
        impl_pl => 'TCL'
    );

    foo := acs_sc_impl_alias.new(
        impl_contract_name => 'RssGenerationSubscriber',
        impl_name => 'pinds_blog_entries',
        impl_operation_name => 'lastUpdated',
        impl_alias => 'lars_blog__rss_lastUpdated',
        impl_pl => 'TCL'
    );

    acs_sc_binding.new (
        contract_name => 'RssGenerationSubscriber',
        impl_name => 'pinds_blog_entries'
     );

end;
/
show errors
