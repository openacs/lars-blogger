--
-- lars-blogger-create.sql
-- 
-- @author Lars Pind
-- 
-- @cvs-id $Id$
--

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


create or replace function pinds_blog_entry__delete (integer)
returns integer as '
declare
    p_entry_id alias for $1;
    comment_rec         record;
begin
    -- delete comments associated with this entry
    for comment_rec in select gc.comment_id 
                         from general_comments gc
                         where gc.object_id = p_entry_id loop
        perform acs_message__delete(comment_rec.comment_id);
    end loop;

    delete from pinds_blog_entries
        where entry_id = p_entry_id;
    PERFORM acs_object__delete(p_entry_id);
    return 0;
end;
' language 'plpgsql';


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
    subscr_rec         record;
begin
    -- delete rss_gen_subscrs which relate to this channel
    for subscr_rec in select subscr_id 
                         from rss_gen_subscrs
                         where summary_context_id = p_channel_id loop
        perform rss_gen_subscr__delete(subscr_rec.subscr_id);
    end loop;

    delete from weblogger_channels
        where channel_id = p_channel_id;
    PERFORM acs_object__delete(p_channel_id);
    return 0;
end;
' language 'plpgsql';

