-- This is a lars blogger implementation of the FtsContentProvider
-- service contract

select acs_sc_impl__new(
    'FtsContentProvider',	        -- impl_contract_name
    'pinds_blog_entry',	            -- impl_name
    'lars-blogger'			        -- impl_owner_name
);

select acs_sc_impl_alias__new(
    'FtsContentProvider',		    -- impl_contract_name
    'pinds_blog_entry',		        -- impl_name
    'datasource',			        -- impl_operation_name
    'pinds_blog_entry__datasource',	-- impl_alias
    'TCL'				            -- impl_pl
);

select acs_sc_impl_alias__new(
    'FtsContentProvider',		    -- impl_contract_name
    'pinds_blog_entry',		        -- impl_name
    'url',				            -- impl_operation_name
    'pinds_blog_entry__url',	    -- impl_alias
    'TCL'				            -- impl_pl
);


create function pinds_blog_entries__itrg ()
returns opaque as '
begin
    if new.draft_p = ''f'' then
        perform search_observer__enqueue(new.entry_id,''INSERT'');
    end if;
    return new;
end;' language 'plpgsql';

create function pinds_blog_entries__dtrg ()
returns opaque as '
begin
    perform search_observer__enqueue(old.entry_id,''DELETE'');
    return old;
end;' language 'plpgsql';

create function pinds_blog_entries__utrg ()
returns opaque as '
begin
    if (new.draft_p = ''t'' and old.draft_p = ''f'') or new.deleted_p = ''t'' then
        perform search_observer__enqueue(old.entry_id,''DELETE'');
    else 
        perform search_observer__enqueue(old.entry_id,''UPDATE'');
    end if;
    return old;
end;' language 'plpgsql';


create trigger pinds_blog_entries__itrg after insert on pinds_blog_entries
for each row execute procedure pinds_blog_entries__itrg ();

create trigger pinds_blog_entries__dtrg after delete on pinds_blog_entries
for each row execute procedure pinds_blog_entries__dtrg ();

create trigger pinds_blog_entries__utrg after update on pinds_blog_entries
for each row execute procedure pinds_blog_entries__utrg ();

-- Add the binding

select acs_sc_binding__new (
    'FtsContentProvider',
    'pinds_blog_entry'
);
