<?xml version="1.0"?>

<queryset>

    <fullquery name="entry">
        <querytext>
		    select title, content, draft_p, to_char(entry_date, 'YYYY-MM-DD') as entry_date
		    from   pinds_blog_entries
		    where  entry_id = :entry_id
        </querytext>
    </fullquery>

</queryset>
