--
-- lars-blogger-drop.sql
-- 
-- @author Lars Pind
-- 
-- @cvs-id $Id$
--

\i notifications-drop.sql
\i rss-unregister.sql

create function inline_0 ()
returns integer as '
declare
	comment_rec			record;
	entry_rec			record;
begin
    -- iterate through all comments on entries
	for comment_rec in select gc.comment_id 
	                     from general_comments gc,
	                          pinds_blog_entries e
                         where gc.object_id = e.entry_id loop
		perform acs_message__delete(comment_rec.comment_id);
	end loop;

	-- iterate through all entries
	for entry_rec in select entry_id from pinds_blog_entries loop
		perform pinds_blog_entry__delete( entry_rec.entry_id );
	end loop;

	return 0;
end;' language 'plpgsql';

select inline_0();
drop function inline_0();

drop function weblogger_channel__new(
    integer,      -- channel_id
    integer,      -- package_id
    integer,      -- user_id
    integer,      -- creation_user
    varchar       -- creation_ip
);

drop function weblogger_channel__delete (integer);

drop table weblogger_channels;
select acs_object_type__drop_type ('weblogger_channel', true);

drop function pinds_blog_entry__title (integer);
drop function pinds_blog_entry__new(
    integer,      -- entry_id
    integer,      -- package_id
    varchar,      -- title
    varchar,      -- title_url
    varchar,      -- content
    varchar,      -- content_format
    timestamptz,  -- entry_date
    char,         -- draft_p
    integer,      -- creation_user
    varchar       -- creation_ip
);
drop function pinds_blog_entry__delete (integer);

drop table pinds_blog_entries;
select acs_object_type__drop_type ('pinds_blog_entry', true);
