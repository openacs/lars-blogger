<?xml version="1.0"?>

<queryset>

    <fullquery name="categories">
        <querytext>
	        select name, category_id
                from   pinds_blog_categories
                where  package_id = :package_id
        </querytext>
    </fullquery>

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
            select title, title_url, category_id, content, content_format, draft_p, to_char(entry_date, 'YYYY-MM-DD') as entry_date
            from   pinds_blog_entries
            where  entry_id = :entry_id
        </querytext>
    </fullquery>

</queryset>
