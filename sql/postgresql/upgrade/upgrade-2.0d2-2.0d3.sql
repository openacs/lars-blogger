create function pinds_blog_entries__utrg()
returns trigger as '
begin
    if (new.draft_p = ''t'' and old.draft_p = ''f'') or new.deleted_p = ''t'' then
        perform search_observer__enqueue(old.entry_id,''DELETE'');
    else 
        perform search_observer__enqueue(old.entry_id,''UPDATE'');
    end if;
    return old;
end;' language 'plpgsql';

create trigger pinds_blog_entries__utrg
after update on pinds_blog_entries for each row execute
procedure pinds_blog_entries__utrg();
