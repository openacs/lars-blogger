-- Drop the lars blogger implementation of the FtsContentProvider
-- service contract

select acs_sc_binding__delete(
    'FtsContentProvider',   -- impl_contract_name
    'pinds_blog_entries'    -- impl_name
);

select acs_sc_impl__delete(
    'FtsContentProvider',   -- impl_contract_name
    'pinds_blog_entries'	-- impl_name
);

select acs_sc_impl_alias__delete(
    'FtsContentProvider',   -- impl_contract_name
    'pinds_blog_entries',   -- impl_name
    'datasource'            -- impl_operation_name
);

select acs_sc_impl_alias__delete(
    'FtsContentProvider',   -- impl_contract_name
    'pinds_blog_entries',   -- impl_name
    'url'                   -- impl_operation_name
);

-- Drop the database triggers on pinds_blog_entries

drop trigger pinds_blog_entries__utrg on pinds_blog_entries;
drop trigger pinds_blog_entries__dtrg on pinds_blog_entries;
drop trigger pinds_blog_entries__itrg on pinds_blog_entries;

drop function pinds_blog_entries__utrg ();
drop function pinds_blog_entries__dtrg ();
drop function pinds_blog_entries__itrg ();

