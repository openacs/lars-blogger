<?xml version="1.0"?>

<queryset>

    <fullquery name="update_entry">
        <querytext>
		    update pinds_blog_entries
		    set    draft_p = 't'
		    where  entry_id = :entry_id
        </querytext>
    </fullquery>

</queryset>
