<?xml version="1.0"?>

<queryset>

    <fullquery name="delete">
        <querytext>
		    update pinds_blog_entries
		    set deleted_p = 't'
		    where entry_id = :entry_id
        </querytext>
    </fullquery>

</queryset>
