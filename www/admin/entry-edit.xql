<?xml version="1.0"?>

<queryset>

    <fullquery name="entry_exists">
        <querytext>
            select count(*) 
            from   pinds_blog_entries 
            where  entry_id = :entry_id 
        </querytext>
    </fullquery>

    <fullquery name="org_draft_p">
        <querytext>
            select draft_p 
            from   pinds_blog_entries 
            where  entry_id = :entry_id
        </querytext>
    </fullquery>

    <fullquery name="entry">
        <querytext>
            select title, title_url, content, content_format, draft_p, to_char(entry_date, 'YYYY-MM-DD') as entry_date
            from   pinds_blog_entries
            where  entry_id = :entry_id
        </querytext>
    </fullquery>

    <fullquery name="update_entry">
        <querytext>
            update pinds_blog_entries
            set    [join $set_clauses ", "]
            where  entry_id = :entry_id
        </querytext>
    </fullquery>

</queryset>
