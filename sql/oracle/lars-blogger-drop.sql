--
-- lars-blogger-drop.sql
-- 
-- @author Lars Pind
-- @author Yon (Yon@milliped.com) Oracle Port
-- @author Vinod Kurup (vinod@kurup.com)
-- 
-- @cvs-id $Id$
--

@@ notifications-drop
@@ rss-unregister

begin
    acs_object_type.drop_type('weblogger_channel', 't');
end;
/
show errors

drop table weblogger_channels;

begin

    for blog_entry in (select entry_id from pinds_blog_entries) loop
		-- delete comments (which are acs_message's)
		for comment in (select comment_id from general_comments 
							   where object_id = blog_entry.entry_id) loop
			acs_message.delete(comment.comment_id);
		end loop;

        pinds_blog_entry.delete(blog_entry.entry_id);
    end loop;

    acs_object_type.drop_type('pinds_blog_entry', 't');

end;
/
show errors


@@ lars-blogger-package-drop

drop table pinds_blog_entries;
