--
-- lars-blogger-create.sql
-- 
-- @author Lars Pind
-- 
-- @cvs-id $Id$
--

select acs_object_type__create_type (
    'pinds_blog_entry',             -- object_type
    'Blog Entry',                   -- pretty_name
    'Blog Entries',                 -- pretty_plural
    'acs_object',                   -- supertype
    'pinds_blog_entries',           -- table_name
    'entry_id',                     -- id_column
    null,                           -- package_name
    'f',                            -- abstract_p
    null,                           -- type_extension_table
    'pinds_blog_entry__title'       -- name_method
);

create table pinds_blog_entries (
  entry_id              integer
                        constraint pinds_blog_entry_id_fk
                        references acs_objects(object_id)
                        constraint pinds_blog_entries_pk
                        primary key,
  package_id            integer
                        constraint pinds_blog_entry_package_id_kf
                        references apm_packages(package_id),
  title                 varchar(500),
  title_url             varchar(500),
  content               varchar(32000),
  content_format        varchar(50) 
                        default 'text/html'
                        constraint pinds_blog_entr_cnt_format_nn
                        not null,
  entry_date            timestamptz,
  posted_date           timestamptz,
  draft_p               char(1) default 'f'
                        constraint pinds_blog_entries_draft_ck
                        check (draft_p in ('t','f')),
  deleted_p             char(1) default 'f'
                        constraint pinds_blog_entries_deleted_ck
                        check (deleted_p in ('t','f'))
);

create index pinds_blog_entry_pck_entr_idx on pinds_blog_entries (package_id, entry_date);

create or replace function pinds_blog_entry__title (integer)
returns varchar as '
declare
    p_entry_id        alias for $1;
    v_title           varchar;
begin
    select title into v_title
        from pinds_blog_entries
        where entry_id = p_entry_id;
    return v_title;
end;
' language 'plpgsql';


create or replace function pinds_blog_entry__new (
    integer,     -- entry_id
    integer,     -- package_id
    varchar,     -- title
    varchar,     -- title_url
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
    p_content              alias for $5;
    p_content_format       alias for $6;
    p_entry_date           alias for $7;
    p_draft_p              alias for $8;
    p_creation_user        alias for $9;
    p_creation_ip          alias for $10;
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


create or replace function pinds_blog_entry__delete (integer)
returns integer as '
declare
    p_entry_id alias for $1;
begin
    delete from pinds_blog_entries
        where entry_id = p_entry_id;
    PERFORM acs_object__delete(p_entry_id);
    return 0;
end;
' language 'plpgsql';


select acs_object_type__create_type (
    'weblogger_channel',        -- object_type
    'Weblogger Channel',        -- pretty_name
    'Weblogger Channels',       -- pretty_plural
    'acs_object',               -- supertype
    'weblogger_channels',       -- table_name
    'channel_id',       	-- id_column
    null,               	-- package_name
    'f',        	        -- abstract_p
    null,   	                -- type_extension_table
    null                        -- name_method
);

create table weblogger_channels (
  channel_id    	integer
                        constraint channel_id_fk
                        references acs_objects(object_id)
                        constraint weblogger_channels_pk
                        primary key,
  package_id            integer
                        constraint weblogger_channels_package_id_kf
                        references apm_packages(package_id),
  user_id		integer,
  constraint weblogger_chnls_package_user_un
  unique (package_id, user_id)
);



create or replace function weblogger_channel__new (
    integer,     -- channel_id
    integer,     -- package_id
    integer,     -- user_id
    integer,     -- creation_user
    varchar      -- creation_ip
) returns integer as '
declare
    p_channel_id           alias for $1;
    p_package_id           alias for $2;
    p_user_id		   alias for $3;
    p_creation_user        alias for $4;
    p_creation_ip          alias for $5;
    v_channel_id           integer;
begin
    v_channel_id := acs_object__new (
        p_channel_id,
        ''weblogger_channel'',
        current_timestamp,
        p_creation_user,
        p_creation_ip,
        p_package_id
    );

    insert into weblogger_channels (
      channel_id, 
      package_id,
      user_id      
    ) values (
      v_channel_id, 
      p_package_id,
      p_user_id
    );

    return v_channel_id;   
end;
' language 'plpgsql';

create or replace function weblogger_channel__delete (integer)
returns integer as '
declare
    p_channel_id alias for $1;
begin
    delete from weblogger_channels
        where channel_id = p_channel_id;
    PERFORM acs_object__delete(p_channel_id);
    return 0;
end;
' language 'plpgsql';

\i rss-register.sql
\i notifications-init.sql
