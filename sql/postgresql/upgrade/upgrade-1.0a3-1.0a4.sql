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
