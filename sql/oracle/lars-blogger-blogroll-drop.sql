--
-- lars-blogger-blogroll-drop.sql
--
-- @author Guan Yang (guan@unicast.org)
-- @author Andrew Grumet (aegrumet@alum.mit.edu)
--

begin

  for blogroll_entry in (select link_id from weblogger_blogroll_entries)
  loop
    weblogger_blogroll_entry.del(blogroll_entry.link_id);
  end loop;

  acs_object_type.drop_type('weblogger_blogroll_entry', 't');

end;
/
show errors

drop table weblogger_blogroll_entries;
drop package body weblogger_blogroll_entry;
drop package weblogger_blogroll_entry;

