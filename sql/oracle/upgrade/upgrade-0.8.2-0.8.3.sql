--
-- Upgrade script
-- 
-- Adds format column
--
-- @author Lars Pind (lars@pinds.com)
-- @creation-date 2003-01-27
--

alter table pinds_blog_entries add content_format varchar(50);

update pinds_blog_entries set content_format = 'text/html';

create or replace package pinds_blog_entry
as

    function new (
        entry_id in pinds_blog_entries.entry_id%TYPE default null,
        package_id in pinds_blog_entries.package_id%TYPE,
        title in pinds_blog_entries.title%TYPE default null,
        content in varchar default null,
        content_format in varchar default 'text/html',
        entry_date in pinds_blog_entries.entry_date%TYPE default null,
        draft_p in pinds_blog_entries.draft_p%TYPE default 'f',
        creation_user in acs_objects.creation_user%TYPE default null,
        creation_ip in acs_objects.creation_ip%TYPE default null
    ) return pinds_blog_entries.entry_id%TYPE;

    procedure delete (
        entry_id in pinds_blog_entries.entry_id%TYPE
    );

    function title (
        entry_id in pinds_blog_entries.entry_id%TYPE
    ) return pinds_blog_entries.title%TYPE;

end pinds_blog_entry;
/
show errors

create or replace package body pinds_blog_entry
as

    function new (
        entry_id in pinds_blog_entries.entry_id%TYPE default null,
        package_id in pinds_blog_entries.package_id%TYPE,
        title in pinds_blog_entries.title%TYPE default null,
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
            content,
            content_format,
            entry_date,
            posted_date,
            draft_p,
            deleted_p
        ) values (
            v_entry_id, 
            pinds_blog_entry.new.package_id,
            pinds_blog_entry.new.title,
            pinds_blog_entry.new.content,
            pinds_blog_entry.new.content_format,
            pinds_blog_entry.new.entry_date,
            sysdate,
            pinds_blog_entry.new.draft_p,
            'f'
        );

        return v_entry_id;

    end new;

    procedure delete (
        entry_id in pinds_blog_entries.entry_id%TYPE
    )
    is
    begin

        delete
        from pinds_blog_entries
        where entry_id = pinds_blog_entry.delete.entry_id;

        acs_object.delete(pinds_blog_entry.delete.entry_id);

    end delete;

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
