-- Add a table for ping URLs i.e. services that use the weblogs.com
-- ping interface.
create table weblogger_ping_urls (
  package_id        integer
                    constraint weblogger_ping_urls_package_id_fk
                    references apm_packages(package_id)
                    on delete cascade,
  ping_url          varchar2(500)
                    constraint weblogger_ping_urls_ping_url_nn
                    not null,
  creation_date     date default sysdate,
  constraint weblogger_ping_urls_pk
  primary key(package_id, ping_url)
);


-- Merge entry_date and posted_date column
update pinds_blog_entries
set    entry_date = to_date(to_char(entry_date, 'YYYY-MM-DD') || ' ' || to_char(posted_date, 'HH24:MI:SS'), 'YYYY-MM-DD HH24:MI:SS');

alter table pinds_blog_entries drop column posted_date;

create or replace package body pinds_blog_entry
as

    function new (
        entry_id in pinds_blog_entries.entry_id%TYPE default null,
        package_id in pinds_blog_entries.package_id%TYPE,
        title in pinds_blog_entries.title%TYPE default null,
        title_url in pinds_blog_entries.title_url%TYPE default null,
        content in varchar default null,
        content_format in varchar default 'text/html',
        entry_date in pinds_blog_entries.entry_date%TYPE default null,
        draft_p in pinds_blog_entries.draft_p%TYPE default 'f',
        creation_user in acs_objects.creation_user%TYPE default null,
        creation_ip in acs_objects.creation_ip%TYPE default null
    ) return pinds_blog_entries.entry_id%TYPE
    is
        v_entry_id pinds_blog_entries.entry_id%TYPE;
    begin

        v_entry_id := acs_object.new(
            object_id => pinds_blog_entry.new.entry_id,
            object_type => 'pinds_blog_entry',
            creation_date => sysdate,
            creation_user => pinds_blog_entry.new.creation_user,
            creation_ip => pinds_blog_entry.new.creation_ip,
            context_id => pinds_blog_entry.new.package_id
        );

        insert into pinds_blog_entries (
            entry_id, 
            package_id,
            title,
            title_url,
            content,
            content_format,
            entry_date,
            draft_p,
            deleted_p
        ) values (
            v_entry_id, 
            pinds_blog_entry.new.package_id,
            pinds_blog_entry.new.title,
            pinds_blog_entry.new.title_url,
            pinds_blog_entry.new.content,
            pinds_blog_entry.new.content_format,
            pinds_blog_entry.new.entry_date,
            pinds_blog_entry.new.draft_p,
            'f'
        );

        return v_entry_id;

    end new;

    procedure del (
        entry_id in pinds_blog_entries.entry_id%TYPE
    )
    is
    begin
        -- delete comments associated with this entry
		for comment in (select comment_id from general_comments 
					      where object_id = pinds_blog_entry.del.entry_id) loop
			acs_message.del(comment.comment_id);
		end loop;

        delete
        from pinds_blog_entries
        where entry_id = pinds_blog_entry.del.entry_id;

        acs_object.del(pinds_blog_entry.del.entry_id);

    end del;

    function title (
        entry_id in pinds_blog_entries.entry_id%TYPE
    ) return pinds_blog_entries.title%TYPE
    is
        v_title pinds_blog_entries.title%TYPE;
    begin

        select title
        into v_title
        from pinds_blog_entries
        where entry_id = pinds_blog_entry.title.entry_id;

        return v_title;

    exception when no_data_found then
        return '';

    end title;

end pinds_blog_entry;
/
show errors
