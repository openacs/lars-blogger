-- Add a table for ping URLs i.e. services that use the weblogs.com
-- ping interface.
create table weblogger_ping_urls (
    package_id      integer
                    constraint weblogger_ping_urls_package_id_fk
                        references apm_packages(package_id)
			on delete cascade,
    ping_url        varchar(500)
                    constraint weblogger_ping_urls_ping_url_nn
                        not null,
    creation_date   timestamptz
			default now(),
    constraint weblogger_ping_urls_pk
        primary key(package_id, ping_url)
);

-- Simple blogroll feature
select acs_object_type__create_type (
    'weblogger_blogroll_entry',         -- object_type
    'Blogroll Entry',                   -- pretty_name
    'Blogroll Entries',                 -- pretty_plural
    'acs_object',                       -- supertype
    'weblogger_blogroll_entries',       -- table_name
    'link_id',                          -- id_column
    'lars-blogger',                     -- package_name
    'f',                                -- abstract_p
    null,                               -- type_extension_table
    'weblogger_blogroll_entry__name'    -- name_method
);

create table weblogger_blogroll_entries (
    link_id             integer
                        constraint weblogger_blogroll_entries_id_fk
                            references acs_objects(object_id)
                        constraint weblogger_blogroll_entries_id_pk
                            primary key,
    package_id          integer
                        constraint weblogger_blogroll_entries_package_id_fk
                            references apm_packages(package_id),
    name                varchar(500)
                        constraint weblogger_blogroll_entries_name_nn
                            not null,
    url                 varchar(1000)
                        constraint weblogger_blogroll_entries_url_nn
                            not null,
    sort_order		integer default 0
);

create or replace function weblogger_blogroll_entry__name (integer)
returns varchar as '
declare
    p_link_id           alias for $1;
    v_name              varchar;
begin
    select name into v_name
        from weblogger_blogroll_entries
        where link_id = p_link_id;
    return v_name;
end;
' language 'plpgsql';

create or replace function weblogger_blogroll_entry__new (
    integer,     -- link_id
    integer,     -- package_id
    varchar,     -- name
    varchar,     -- url
    integer,     -- creation_user
    varchar      -- creation_ip
) returns integer as '
declare
    p_link_id               alias for $1;
    p_package_id           alias for $2;
    p_name                 alias for $3;
    p_url           alias for $4;
    p_creation_user        alias for $5;
    p_creation_ip          alias for $6;
    v_link_id          integer;
begin
    v_link_id := acs_object__new (
        p_link_id,
        ''weblogger_blogroll_entry'',
        current_timestamp,
        p_creation_user,
        p_creation_ip,
        p_package_id
    );

    insert into weblogger_blogroll_entries (
      link_id, 
      package_id,
      name,
      url
    ) values (
      v_link_id, 
      p_package_id,
      p_name,
      p_url
    );

    return v_link_id;   
end;
' language 'plpgsql';

create or replace function weblogger_blogroll_entry__delete (integer)
returns integer as '
declare
    p_link_id alias for $1;
begin
    delete from weblogger_blogroll_entries
        where link_id = p_link_id;

    PERFORM acs_object__delete(p_link_id);
    return 0;
end;
' language 'plpgsql';


-- Merge entry_date and posted_date column
update pinds_blog_entries
set    entry_date = to_timestamp(to_char(entry_date, 'YYYY-MM-DD') || ' ' || to_char(posted_date, 'HH24:MI:SS'), 'YYYY-MM-DD HH24:MI:SS');

alter table pinds_blog_entries drop column posted_date;


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

-- Cache for the Technorati API calls
create table weblogger_technorati_cache (
    package_id      integer
                    constraint weblogger_ping_urls_package_id_fk
                        references apm_packages(package_id)
                        on delete cascade,
    name            varchar(500),
    url             varchar(500),
    creation_date   timestamptz
			default now()
);

