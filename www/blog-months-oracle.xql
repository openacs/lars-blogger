<?xml version="1.0"?>

<queryset>
    <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

    <fullquery name="all_blog_months">
        <querytext>
			select trunc(entry_date, 'month') as month_date,
			       to_char(trunc(entry_date, 'month'), 'fmMonthfm YYYY')
					  as date_pretty,
			       to_char(trunc(entry_date, 'month'), 'YYYY/MM/')
					  as month_url_stub
			from   pinds_blog_entries
			where  draft_p = 'f'
			and    package_id = :package_id
			group  by trunc(entry_date, 'month')
			order  by month_date desc
        </querytext>
    </fullquery>

    <fullquery name="one_blog_months">
        <querytext>
			select trunc(entry_date, 'month') as month_date,
			       to_char(trunc(entry_date, 'month'), 'fmMonthfm YYYY')
					  as date_pretty,
			       to_char(trunc(entry_date, 'month'), 'YYYY/MM/')
					  as month_url_stub
			from   pinds_blog_entries e, users u
			where  draft_p = 'f'
			and    package_id = :package_id
			and    screen_name = :screen_name
			and    u.user_id = e.user_id
			group  by trunc(entry_date, 'month')
			order  by month_date desc
        </querytext>
    </fullquery>

</queryset>
