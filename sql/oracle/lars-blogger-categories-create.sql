--
-- lars-blogger-categories-create.sql
-- 
-- @author Steffen Tiedemann Christensen
-- 
-- @cvs-id $Id$
--


declare
begin
    acs_object_type.create_type (
        object_type => 'pinds_blog_category',
        pretty_name => 'Blog Category',
        pretty_plural => 'Blog Categories',
        supertype => 'acs_object',
        table_name => 'pinds_blog_categories',
        id_column => 'category_id',
        package_name => 'pinds_blog_category',
        abstract_p => 'f',
        name_method => 'pinds_blog_category.name'
    );
end;
/
show errors


create table pinds_blog_categories (
  category_id           integer
                        constraint pinds_blog_category_id_fk
                        references acs_objects(object_id)
                        constraint pinds_blog_categories_pk
                        primary key,
  package_id            integer
                        constraint pinds_blog_entry_package_id_kf
                        references apm_packages(package_id),
  name                  varchar2(4000) not null,
  short_name            varchar2(4000) not null
);


