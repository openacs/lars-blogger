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
            select entry_id,
                   title, 
                   content,
                   entry_date,
                   posted_date,
                   to_char(posted_date, 'YYYY-MM-DD') as posted_date_string,
                   to_char(posted_date, 'HH:MI') as posted_time_string,
                   extract(timezone_hour from now()) as tzoffset_hour,
                   extract(timezone_minute from now()) as tzoffset_minute,
                   to_char(entry_date, 'DD Mon YYYY hh12:MI am') as entry_date_pretty,
                   to_char(entry_date, 'YYYY/MM/') as entry_archive_url
    
            from pinds_blog_entries
            where package_id = :package_id
            and draft_p = 'f'
            and deleted_p = 'f'
            order by entry_date desc, posted_date desc
            limit 10
        </querytext>
    </fullquery>

    <fullquery name="lars_blog__rss_lastUpdated.get_last_update">
        <querytext>
                select coalesce (date_part('epoch',
                                max(posted_date::timestamptz)
                                ),0) as last_update
                from   pinds_blog_entries
	        where  package_id = :package_id
	        and    draft_p = 'f'
	        and    deleted_p = 'f'
        </querytext>
    </fullquery>

</queryset>
