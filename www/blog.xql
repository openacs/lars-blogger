<?xml version="1.0"?>

<queryset>
    <fullquery name="num_entries_by_date_all">
        <querytext>
		    select count(entry_id)
		    from   pinds_blog_entries e
		    where  package_id = :package_id
		    and    $date_clause
		    and    draft_p = 'f'
		    and    deleted_p = 'f'
        </querytext>
    </fullquery>

    <fullquery name="num_entries_by_date">
        <querytext>
		    select count(entry_id)
		    from   pinds_blog_entries e,
                           acs_objects i
		    where  e.package_id = :package_id
                    and    o.object_id = e.entry_id
                    and    o.creation_user = :blog_user_id
		    and    $date_clause
		    and    draft_p = 'f'
		    and    deleted_p = 'f'
        </querytext>
    </fullquery>

</queryset>
