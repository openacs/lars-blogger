--
-- lars-blogger-categories-drop.sql
-- 
-- @author Steffen Tiedemann Christensen
-- 

--STC
drop function pinds_blog_category__new (integer, integer, varchar, varchar, integer, varchar);
drop function pinds_blog_category__name (integer);
drop function pinds_blog_category__delete (integer);
drop table pinds_blog_categories;
select acs_object_type__drop_type ('pinds_blog_category', true);
