<?xml version="1.0"?>

<queryset>
    <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

    <fullquery name="lars_blog__rss_datasource.now">
        <querytext>
			select to_char(sysdate,'DD Mon YYYY hh12:MI am')  from dual
        </querytext>
    </fullquery>

    <fullquery name="lars_blog__rss_datasource.blog_rss_items">
        <querytext>
            select *
            from (select entry_id,
                         e.title, 
                         e.content,
                         to_char(e.entry_date, 'YYYY-MM-DD HH24:MI:SS') as entry_date_ansi,
                         c.name as category
                  from   pinds_blog_entries e,
                         pinds_blog_categories c
                  where  e.package_id = :package_id
                  and    e.draft_p = 'f'
                  and    e.deleted_p = 'f'
                  and    c.category_id (+) = e.category_id
                  order  by e.entry_date desc)
            where rownum < 11
        </querytext>
    </fullquery>

    <fullquery name="lars_blog__rss_datasource.user_blog_rss_items">
        <querytext>
            select *
            from (select e.entry_id,
                         e.title, 
                         e.content,
                         to_char(e.entry_date, 'YYYY-MM-DD HH24:MI:SS') as entry_date_ansi,
                         c.name as category
                  from   pinds_blog_entries e,
		         acs_objects o, 
                         users u,
                         pinds_blog_categories c
                  where  e.package_id = :package_id
                  and    o.object_id = e.entry_id
                  and    o.creation_user = :user_id
                  and    u.user_id = o.creation_user
                  and    e.draft_p = 'f'
                  and    e.deleted_p = 'f'
                  and    c.category_id = e.category_id (+)
                  order  by e.entry_date desc)
            where rownum < 11
        </querytext>
    </fullquery>

    <fullquery name="lars_blog__rss_lastUpdated.get_last_update">
        <querytext>
	        select nvl ((max(entry_date)-to_date('1970-01-01'))*60*60*24,0) as last_update
	        from   pinds_blog_entries
	        where  package_id = :package_id
	        and    draft_p = 'f'
	        and    deleted_p = 'f'
        </querytext>
    </fullquery>

    <fullquery name="lars_blog__rss_lastUpdated.get_last_user_update">
        <querytext>
	        select nvl ((max(entry_date)-to_date('1970-01-01'))*60*60*24,0) as last_update
	        from   pinds_blog_entries e join
                       acs_objects o on (o.object_id = e.entry_id)
	        where  e.package_id = :package_id
                and    o.creation_user = :user_id
	        and    e.draft_p = 'f'
	        and    e.deleted_p = 'f'
        </querytext>
    </fullquery>

</queryset>
