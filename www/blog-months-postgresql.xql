<?xml version="1.0"?>

<queryset>
    <rdbms><type>postgresql</type><version>7.1</version></rdbms>

    <fullquery name="months">
        <querytext>
			select date_trunc('month', entry_date) as month_date,
			       to_char(date_trunc('month', entry_date), 'fmMonthfm, YYYY')
					  as date_pretty,
			       to_char(date_trunc('month', entry_date), 'YYYY/MM/')
					  as month_url_stub,
			       '' as url
			from   pinds_blog_entries
			where  draft_p = 'f'
			and    package_id = :package_id
			group  by month_date
			order  by month_date desc
        </querytext>
    </fullquery>

</queryset>
