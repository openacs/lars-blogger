<?xml version="1.0"?>

<queryset>

    <fullquery name="draft_entries">
        <querytext>
		    select e.entry_id,
		           to_char(e.entry_date, 'YYYY-MM-DD HH24:MI:SS') as entry_date_ansi, 
		           e.title,
		           e.content,
                           o.creation_user,
                           u.first_names,
                           u.last_name
		    from   pinds_blog_entries e,
                           acs_objects o,
                           acs_users_all u
		    where  e.package_id = :package_id
		    and    e.draft_p = 't'
		    and    e.deleted_p = 'f'
                    and    o.object_id = e.entry_id
                    and    u.user_id = o.creation_user
                    and    o.creation_user = :user_id
		    order  by e.entry_date desc
        </querytext>
    </fullquery>

    <fullquery name="all_draft_entries">
        <querytext>
		    select e.entry_id,
		           to_char(e.entry_date, 'YYYY-MM-DD HH24:MI:SS') as entry_date_ansi, 
		           e.title,
		           e.content,
                           o.creation_user,
                           u.first_names,
                           u.last_name
		    from   pinds_blog_entries e,
                           acs_objects o,
                           acs_users_all u
		    where  e.package_id = :package_id
		    and    e.draft_p = 't'
		    and    e.deleted_p = 'f'
                    and    o.object_id = e.entry_id
                    and    u.user_id = o.creation_user
		    order  by e.entry_date desc
        </querytext>
    </fullquery>

</queryset>
