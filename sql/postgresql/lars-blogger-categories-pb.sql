--
-- lars-blogger-categories-pb.sql
-- 
-- @author Steffen Tiedemann Christensen
-- 
-- @cvs-id $Id$
--

create or replace function pinds_blog_category__name (integer)
returns varchar as '
declare
    p_category_id     alias for $1;
    v_name            varchar;
begin
    select name into v_name
        from pinds_blog_categories
        where category_id = p_category_id;
    return v_name;
end;
' language 'plpgsql';

create or replace function pinds_blog_category__new (
    integer,     -- category_id
    integer,     -- package_id
    varchar,     -- name
    varchar,     -- short_name
    integer,     -- creation_user
    varchar      -- creation_ip
) returns integer as '
declare
    p_category_id          alias for $1;
    p_package_id           alias for $2;
    p_name                 alias for $3;
    p_short_name           alias for $4;
    p_creation_user        alias for $5;
    p_creation_ip          alias for $6;
    v_category_id          integer;
begin
    v_category_id := acs_object__new (
        p_category_id,
        ''pinds_blog_category'',
        current_timestamp,
        p_creation_user,
        p_creation_ip,
        p_package_id
    );

    insert into pinds_blog_categories (
      category_id, 
      package_id,
      name,
      short_name
    ) values (
      v_category_id, 
      p_package_id,
      p_name,
      p_short_name
    );

    return v_category_id;   
end;
' language 'plpgsql';

create or replace function pinds_blog_category__delete (integer)
returns integer as '
declare
    p_category_id alias for $1;
begin
    update pinds_blog_entries
        set category_id = null
        where category_id = p_category_id;

    delete from pinds_blog_categories
        where category_id = p_category_id;

    PERFORM acs_object__delete(p_category_id);
    return 0;
end;
' language 'plpgsql';
