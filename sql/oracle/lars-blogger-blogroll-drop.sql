--
-- lars-blogger-categories-drop.sql
--
-- @author Guan Yang (guan@unicast.org)
--

drop function weblogger_blogroll_entry__delete(integer);
drop function weblogger_blogroll_entry__new(integer, integer, varchar, varchar, integer, varchar);
drop function weblogger_blogroll_entry__name(integer);
drop table weblogger_blogroll_entries;
select acs_object_type__drop_type('weblogger_blogroll_entry', true);