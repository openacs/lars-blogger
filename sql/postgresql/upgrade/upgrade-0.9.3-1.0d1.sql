
select acs_object_type__create_type (
    'pinds_blog_category',          -- object_type
    'Blog Category',                -- pretty_name
    'Blog Categories',              -- pretty_plural
    'acs_object',                   -- supertype
    'pinds_blog_categories',        -- table_name
    'category_id',                  -- id_column
    null,                           -- package_name
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
  name                  varchar(500) not null,
  short_name            varchar(50) not null
);

create or replace function pinds_blog_category__name (integer)
returns varchar as '
declare
    p_category_id     alias for $1;
    v_name            varchar;
begin
    select title into v_name
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
        set category_id = 0
        where category_id = p_category_id;

    delete from pinds_blog_categories
        where category_id = p_category_id;

    PERFORM acs_object__delete(p_category_id);
    return 0;
end;
' language 'plpgsql';


alter table pinds_blog_entries add column category_id integer;
--alter table pinds_blog_entries alter column category_id set not null;


drop function pinds_blog_entry__new (
    integer, integer, varchar, varchar, varchar, varchar, timestamptz,  char, integer, varchar
);


create or replace function pinds_blog_entry__new (
    integer,     -- entry_id
    integer,     -- package_id
    varchar,     -- title
    varchar,     -- title_url
    integer,     -- category_id
    varchar,     -- content
    varchar,     -- content_format
    timestamptz, -- entry_date
    char,        -- draft_p
    integer,     -- creation_user
    varchar      -- creation_ip
) returns integer as '
declare
    p_entry_id             alias for $1;
    p_package_id           alias for $2;
    p_title                alias for $3;
    p_title_url            alias for $4;
    p_category_id          alias for $5;
    p_content              alias for $6;
    p_content_format       alias for $7;
    p_entry_date           alias for $8;
    p_draft_p              alias for $9;
    p_creation_user        alias for $10;
    p_creation_ip          alias for $11;
    v_entry_id             integer;
begin
    v_entry_id := acs_object__new (
        p_entry_id,
        ''pinds_blog_entry'',
        current_timestamp,
        p_creation_user,
        p_creation_ip,
        p_package_id
    );

    insert into pinds_blog_entries (
      entry_id, 
      package_id,
      title,
      title_url,
      category_id,
      content,
      content_format,
      entry_date,
      posted_date,
      draft_p,
      deleted_p
    ) values (
      v_entry_id, 
      p_package_id,
      p_title,
      p_title_url,
      p_category_id,
      p_content,
      p_content_format,
      p_entry_date,
      current_timestamp,
      p_draft_p,
      ''f''
    );

    PERFORM acs_permission__grant_permission(
        v_entry_id,
	p_creation_user,
	''admin''
    );

    return v_entry_id;   
end;
' language 'plpgsql';
