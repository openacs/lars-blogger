<?xml version="1.0"?>

<queryset>
    <rdbms><type>postgresql</type><version>7.1</version></rdbms>

    <fullquery name="all_blog_months">
        <querytext>
			select date_trunc('month', entry_date) as month_date,
			       to_char(date_trunc('month', entry_date), 'fmMonthfm YYYY')
					  as date_pretty,
			       to_char(date_trunc('month', entry_date), 'YYYY/MM/')
					  as month_url_stub
			from   pinds_blog_entries
			where  draft_p = 'f'
			and    package_id = :package_id
			group  by month_date
			order  by month_date desc
        </querytext>
    </fullquery>

    <fullquery name="one_blog_months">
        <querytext>
			select date_trunc('month', entry_date) as month_date,
			       to_char(date_trunc('month', entry_date), 'fmMonthfm YYYY')
					  as date_pretty,
			       to_char(date_trunc('month', entry_date), 'YYYY/MM/')
					  as month_url_stub
			 from  pinds_blog_entries e join
                               acs_objects o on (o.object_id = e.entry_id) join
                               users u on (u.user_id = o.creation_user)
                        where  package_id = :package_id
			and    draft_p = 'f'
			and    screen_name = :screen_name
			group  by month_date
			order  by month_date desc
        </querytext>
    </fullquery>

</queryset>
