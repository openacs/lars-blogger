<?xml version="1.0"?>

<queryset>
    <rdbms><type>postgresql</type><version>7.1</version></rdbms>

    <fullquery name="lars_blog__rss_datasource.now">
        <querytext>
			select to_char(current_timestamp,'DD Mon YYYY hh12:MI am') 
        </querytext>
    </fullquery>

    <fullquery name="lars_blog__rss_datasource.blog_rss_items">
        <querytext>
            select e.entry_id,
                   e.title, 
                   e.content,
                   to_char(e.entry_date, 'YYYY-MM-DD HH24:MI:SS') as entry_date_ansi,
                   c.name as category
            from   pinds_blog_entries e left outer join
                   pinds_blog_categories c using (category_id)
            where  e.package_id = :package_id
            and    e.draft_p = 'f'
            and    e.deleted_p = 'f'
            order  by e.entry_date desc
            limit  10
        </querytext>
    </fullquery>

    <fullquery name="lars_blog__rss_datasource.user_blog_rss_items">
        <querytext>
            select e.entry_id,
                   e.title, 
                   e.content,
                   to_char(e.entry_date, 'YYYY-MM-DD HH24:MI:SS') as entry_date_ansi,
                   c.name as category
            from   pinds_blog_entries e join 
                   acs_objects o on (o.object_id = e.entry_id) join 
	           users u on (u.user_id = o.creation_user) left outer join
                   pinds_blog_categories c using (category_id)
            where  e.package_id = :package_id
            and    o.creation_user = :user_id
            and    e.draft_p = 'f'
            and    e.deleted_p = 'f'
            order  by e.entry_date desc
            limit  10
        </querytext>
    </fullquery>

    <fullquery name="lars_blog__rss_lastUpdated.get_last_update">
        <querytext>
                select coalesce (date_part('epoch',
                                max(entry_date::timestamptz)
                                ),0) as last_update
                from   pinds_blog_entries
	        where  package_id = :package_id
	        and    draft_p = 'f'
	        and    deleted_p = 'f'
        </querytext>
    </fullquery>

    <fullquery name="lars_blog__rss_lastUpdated.get_last_user_update">
        <querytext>
                select coalesce (date_part('epoch',
                                max(e.entry_date::timestamptz)
                                ),0) as last_update
                from   pinds_blog_entries e join 
		       acs_objects o on (o.object_id = e.entry_id)
	        where  e.package_id = :package_id
                and    o.creation_user = :user_id
	        and    e.draft_p = 'f'
	        and    e.deleted_p = 'f'
        </querytext>
    </fullquery>

</queryset>
