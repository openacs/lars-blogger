--
-- lars-blogger-package-create.sql
-- 
-- @author Lars Pind
-- @author Yon (Yon@milliped.com) Oracle Port
-- 
-- @cvs-id $Id$
--

create or replace package pinds_blog_entry
as

    function new (
        entry_id in pinds_blog_entries.entry_id%TYPE default null,
        package_id in pinds_blog_entries.package_id%TYPE,
        title in pinds_blog_entries.title%TYPE default null,
        title_url in pinds_blog_entries.title_url%TYPE default null,
        content in varchar default null,
        category_id pinds_blog_entries.category_id%TYPE default null,
        content_format in varchar default 'text/html',
        entry_date in pinds_blog_entries.entry_date%TYPE default null,
        draft_p in pinds_blog_entries.draft_p%TYPE default 'f',
        creation_user in acs_objects.creation_user%TYPE default null,
        creation_ip in acs_objects.creation_ip%TYPE default null
    ) return pinds_blog_entries.entry_id%TYPE;

    procedure del (
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
        title_url in pinds_blog_entries.title_url%TYPE default null,
        content in varchar default null,
        category_id pinds_blog_entries.category_id%TYPE default null,
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
            category_id,
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
            pinds_blog_entry.new.category_id,
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

create or replace package weblogger_channel
as

    function new (
        channel_id in weblogger_channels.channel_id%TYPE default null,
        package_id in weblogger_channels.package_id%TYPE,
        user_id in weblogger_channels.user_id%TYPE default null,
        creation_user in acs_objects.creation_user%TYPE default null,
        creation_ip in acs_objects.creation_ip%TYPE default null
    ) return weblogger_channels.channel_id%TYPE;

    procedure del (
        channel_id in weblogger_channels.channel_id%TYPE
    );

end weblogger_channel;
/
show errors


create or replace package body weblogger_channel
as

    function new (
        channel_id in weblogger_channels.channel_id%TYPE default null,
        package_id in weblogger_channels.package_id%TYPE,
        user_id in weblogger_channels.user_id%TYPE default null,
        creation_user in acs_objects.creation_user%TYPE default null,
        creation_ip in acs_objects.creation_ip%TYPE default null
    ) return weblogger_channels.channel_id%TYPE
    is
        v_channel_id weblogger_channels.channel_id%TYPE;
    begin

        v_channel_id := acs_object.new(
            object_id => weblogger_channel.new.channel_id,
            object_type => 'weblogger_channel',
            creation_date => sysdate,
            creation_user => weblogger_channel.new.creation_user,
            creation_ip => weblogger_channel.new.creation_ip,
            context_id => weblogger_channel.new.package_id
        );

        insert into weblogger_channels (
           channel_id, 
           package_id,
           user_id      
        ) values (
           v_channel_id, 
           weblogger_channel.new.package_id,
           weblogger_channel.new.user_id
        );

        return v_channel_id;

    end new;

    procedure del (
        channel_id in weblogger_channels.channel_id%TYPE
    )
    is
    begin
        -- delete rss_gen_subscrs which relate to this channel
		for subscr in (select subscr_id from rss_gen_subscrs
		      where summary_context_id = weblogger_channel.del.channel_id) loop
			rss_gen_subscr.del(subscr.subscr_id);
		end loop;

        delete
        from weblogger_channels
        where channel_id = weblogger_channel.del.channel_id;

        acs_object.del(weblogger_channel.del.channel_id);

    end del;

end weblogger_channel;
/
show errors






create or replace package pinds_blog_category
as
    function name (
        object_id in acs_objects.object_id%TYPE
    ) return varchar2;

    function new (
        category_id in pinds_blog_categories.category_id%TYPE,
        package_id in pinds_blog_categories.package_id%TYPE,
        name in pinds_blog_categories.name%TYPE,
        short_name in pinds_blog_categories.short_name%TYPE,
        creation_user in acs_objects.creation_user%TYPE,
        creation_ip in acs_objects.creation_ip%TYPE
    ) return integer;

    procedure del (
        category_id in pinds_blog_categories.category_id%TYPE
    );
end pinds_blog_category;
/
show errors


create or replace package body pinds_blog_category
as

    function name (
        object_id in acs_objects.object_id%TYPE
    ) return varchar2
    is
        v_name            varchar2(4000);
    begin
        select name
        into   v_name
        from   pinds_blog_categories
        where  category_id = pinds_blog_category.name.object_id;
        return v_name;
    end;

    function new (
        category_id in pinds_blog_categories.category_id%TYPE,
        package_id in pinds_blog_categories.package_id%TYPE,
        name in pinds_blog_categories.name%TYPE,
        short_name in pinds_blog_categories.short_name%TYPE,
        creation_user in acs_objects.creation_user%TYPE,
        creation_ip in acs_objects.creation_ip%TYPE
    ) return integer
    is
        v_category_id          integer;
    begin
        v_category_id := acs_object.new (
            object_id => pinds_blog_category.new.category_id,
            object_type => 'pinds_blog_category',
            creation_user => pinds_blog_category.new.creation_user,
            creation_ip => pinds_blog_category.new.creation_ip,
            context_id => pinds_blog_category.new.package_id
        );

        insert into pinds_blog_categories (
            category_id, 
            package_id,
            name,
            short_name
        ) values (
            v_category_id, 
            pinds_blog_category.new.package_id,
            pinds_blog_category.new.name,
            pinds_blog_category.new.short_name
        );

        return v_category_id;   
    end;

    procedure del (
        category_id in pinds_blog_categories.category_id%TYPE
    )
    is
    begin
        update pinds_blog_entries
        set    category_id = null
        where  category_id = pinds_blog_category.del.category_id;

        delete 
        from   pinds_blog_categories
        where  category_id = pinds_blog_category.del.category_id;

        acs_object.del(pinds_blog_category.del.category_id);
    end;


end pinds_blog_category;
/
show errors
