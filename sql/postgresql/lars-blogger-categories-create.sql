--
-- lars-blogger-categories-create.sql
-- 
-- @author Steffen Tiedemann Christensen
-- 
-- @cvs-id $Id$
--


select acs_object_type__create_type (
    'pinds_blog_category',          -- object_type
    'Blog Category',                -- pretty_name
    'Blog Categories',              -- pretty_plural
    'acs_object',                   -- supertype
    'pinds_blog_categories',        -- table_name
    'category_id',                  -- id_column
    'pinds_blog_category',          -- package_name
    'f',                            -- abstract_p
    null,                           -- type_extension_table
    'pinds_blog_category__name'     -- name_method
);

create table pinds_blog_categories (
  category_id           integer
                        constraint pinds_blog_category_id_fk
                        references acs_objects(object_id)
                        constraint pinds_blog_categories_pk
                        primary key,
  package_id            integer
                        constraint pinds_blog_entry_package_id_kf
                        references apm_packages(package_id),
  name                  varchar(4000) not null,
  short_name            varchar(4000) not null
);

\i lars-blogger-categories-pb.sql
