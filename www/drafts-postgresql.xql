<?xml version="1.0"?>

<queryset>

    <fullquery name="draft_entries">
        <querytext>
		    select entry_id,
		           to_char(entry_date, 'YYYY-MM-DD') as entry_date_pretty, 
		           title,
		           content
		    from   pinds_blog_entries e join
                           acs_objects o on (o.object_id = e.entry_id) join
                           persons p on (p.person_id = o.creation_user)
		    where  package_id = :package_id
                    and    o.creation_user = :user_id
		    and    draft_p = 't'
		    and    deleted_p = 'f'
		    order  by entry_date desc, posted_date desc
        </querytext>
    </fullquery>

</queryset>
