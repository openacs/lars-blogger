-- Index the existing blog entries
--
-- @author Bart Teeuwisse (bart.teeuwisse@thecodemill.biz)
-- @creation-date 2002-11-18

create function inline_0 ()
returns integer as '
declare
    blog_entry pinds_blog_entries%rowtype;
begin

    for blog_entry in select * from pinds_blog_entries where draft_p = ''f'' and deleted_p = ''f'' loop
        perform search_observer__enqueue(blog_entry.entry_id, ''INSERT'');
    end loop;

    return null;
end;' language 'plpgsql';

select inline_0();
drop function inline_0 ();
