--
-- Upgrade script
-- 
-- Binds the service contract if it isn't already bound
--
-- @author Lars Pind (lars@pinds.com)
-- @creation-date 2003-01-30
--

declare
    exists_p integer;
begin

    exists_p := acs_sc_binding.exists_p(
        contract_name => 'RssGenerationSubscriber',
        impl_name => 'pinds_blog_entries'
    );

    if exists_p = 0 then
        acs_sc_binding.new (
            contract_name => 'RssGenerationSubscriber',
            impl_name => 'pinds_blog_entries'
        );
    end if;

end;
/
show errors
