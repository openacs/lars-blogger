<?xml version="1.0"?>

<queryset>

    <fullquery name="archive_date_month">
        <querytext>
			select to_date(:year || :month, 'YYYYMM') 
				as archive_date, 
			to_char(to_date(:year || :month, 'YYYYMM'), 'fmMonthfm YYYY')
				as archive_date_pretty
			from dual
        </querytext>
    </fullquery>

    <fullquery name="archive_date_month_day">
        <querytext>
			select to_date(:year || :month || :day, 'YYYYMMDD') 
				as archive_date, 
			to_char(to_date(:year || :month || :day, 'YYYYMMDD'), 'fmMonthfm YYYY') 
				as archive_month_pretty,
			to_char(to_date(:year || :month || :day, 'YYYYMMDD'), 'DD') 
				as archive_date_pretty
			from dual
        </querytext>
    </fullquery>

    <fullquery name="bloggers">
        <querytext>
		    select distinct screen_name
		    from   pinds_blog_entries e join 
		           acs_objects o on (o.object_id = e.entry_id) join 
		           users u on (u.user_id = o.creation_user)
		    where  package_id = :package_id
        </querytext>
    </fullquery>

</queryset>
