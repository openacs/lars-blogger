<?xml version="1.0"?>

<queryset>
    <fullquery name="num_entries">
        <querytext>
		    select count(entry_id)
		    from   pinds_blog_entries e
		    where  package_id = :package_id
		    and    $date_clause
		    and    draft_p = 'f'
		    and    deleted_p = 'f'
        </querytext>
    </fullquery>

</queryset>
