<?xml version="1.0"?>

<queryset>
    <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

    <fullquery name="update_entry">
        <querytext>
		    update pinds_blog_entries
		    set    entry_date = trunc(sysdate),
		           draft_p = 'f',
		           posted_date = sysdate
		    where  entry_id = :entry_id
        </querytext>
    </fullquery>

</queryset>
