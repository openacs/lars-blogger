<?xml version="1.0"?>

<queryset>
    <rdbms><type>postgresql</type><version>7.1</version></rdbms>

    <fullquery name="update_entry">
        <querytext>
		    update pinds_blog_entries
		    set    entry_date = date_trunc('day', current_timestamp),
		           draft_p = 'f',
		           posted_date = current_timestamp
		    where  entry_id = :entry_id
        </querytext>
    </fullquery>

</queryset>
