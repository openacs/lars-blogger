--
-- Upgrade script
-- 
-- Adds the title_url column to blog entries and __new function
--
-- @author Lars Pind (lars@pinds.com)
-- @creation-date 2003-03-13
--

alter table pinds_blog_entries add 
  title_url             varchar(500);

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

    return v_entry_id;   
end;
' language 'plpgsql';

