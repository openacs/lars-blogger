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


create or replace package pinds_blog_category
as
    function name (
        object_id in acs_objects.object_id%TYPE
    ) return varchar2;

    function new (
        category_id in pinds_blog_categories.category_id%TYPE,
        package_id in pinds_blog_categories.package_id%TYPE,
        name in pinds_blog_categories.name%TYPE,
        short_name in pinds_blog_categories.short_name%TYPE,
        creation_user in acs_objects.creation_user%TYPE,
        creation_ip in acs_objects.creation_ip%TYPE
    ) return integer;

    procedure del (
        category_id in pinds_blog_categories.category_id%TYPE
    );
end pinds_blog_category;
/
show errors


create or replace package body pinds_blog_category
as

    function name (
        object_id in acs_objects.object_id%TYPE
    ) return varchar2
    is
        v_name            varchar2(4000);
    begin
        select name
        into   v_name
        from   pinds_blog_categories
        where  category_id = pinds_blog_category.name.object_id;
        return v_name;
    end;

    function new (
        category_id in pinds_blog_categories.category_id%TYPE,
        package_id in pinds_blog_categories.package_id%TYPE,
        name in pinds_blog_categories.name%TYPE,
        short_name in pinds_blog_categories.short_name%TYPE,
        creation_user in acs_objects.creation_user%TYPE,
        creation_ip in acs_objects.creation_ip%TYPE
    ) return integer
    is
        v_category_id          integer;
    begin
        v_category_id := acs_object.new (
            object_id => pinds_blog_category.new.category_id,
            object_type => 'pinds_blog_category',
            creation_user => pinds_blog_category.new.creation_user,
            creation_ip => pinds_blog_category.new.creation_ip,
            context_id => pinds_blog_category.new.package_id
        );

        insert into pinds_blog_categories (
            category_id, 
            package_id,
            name,
            short_name
        ) values (
            v_category_id, 
            pinds_blog_category.new.package_id,
            pinds_blog_category.new.name,
            pinds_blog_category.new.short_name
        );

        return v_category_id;   
    end;

    procedure del (
        category_id in pinds_blog_categories.category_id%TYPE
    )
    is
    begin
        update pinds_blog_entries
        set    category_id = null
        where  category_id = pinds_blog_category.del.category_id;

        delete 
        from   pinds_blog_categories
        where  category_id = pinds_blog_category.del.category_id;

        acs_object.del(pinds_blog_category.del.category_id);
    end;


end pinds_blog_category;
/
show errors


alter table pinds_blog_entries add column category_id integer;
--alter table pinds_blog_entries alter column category_id set not null;
