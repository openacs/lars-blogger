--
-- Upgrade script
-- 
-- @author Simon Carstensen (simon@collaboraid.biz)
-- @creation-date 2003-06-13
--

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

select acs_object_type__create_type (
    'weblogger_channel',        -- object_type
    'Weblogger Channel',        -- pretty_name
    'Weblogger Channels',       -- pretty_plural
    'acs_object',               -- supertype
    'weblogger_channels',       -- table_name
    'channel_id',               -- id_column
    null,                       -- package_name
    'f',                        -- abstract_p
    null,                       -- type_extension_table
    null                        -- name_method
);

create table weblogger_channels (
  channel_id            integer
                        constraint channel_id_fk
                        references acs_objects(object_id)
                        constraint weblogger_channels_pk
                        primary key,
  package_id            integer
                        constraint weblogger_channels_package_id_kf
                        references apm_packages(package_id),
  user_id               integer,
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
    p_user_id              alias for $3;
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

-- Remove the new parameter rss_file_name and update the old one
-- We do this since the APM does not know that the old parameter
-- has been replaced and we want to retain the values of the old parameter
create function inline_0 ()
returns integer as '
declare
    v_parameter_id integer;
begin
  select parameter_id into v_parameter_id
  from apm_parameters
  where parameter_name = ''rss_file_name'';

  perform apm__unregister_parameter(v_parameter_id);

  return 0;
end;
' language 'plpgsql';
select inline_0 ();
drop function inline_0 ();

update apm_parameters
        set parameter_name = 'rss_file_name',
            description = 'What name should we advertise the RSS feed under, relative to the blog mount point. Leave blank if no RSS feed.',
            default_value = 'rss.xml'
        where parameter_name = 'rss_file_url';


-- missing: create weblogger_channels


