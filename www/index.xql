<?xml version="1.0"?>

<queryset>

    <fullquery name="archive_date_year">
        <querytext>
			select to_date(:year || '-01-01') 
				as archive_date, 
			to_char(to_date(:year || '-01-01'), 'YYYY')
				as archive_date_pretty
			from dual
        </querytext>
    </fullquery>

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

    <fullquery name="get_category_from_short_name">
        <querytext>
			select category_id, name as category_name
			from pinds_blog_categories
			where short_name = :category_short_name and package_id = :package_id
        </querytext>
    </fullquery>

    <fullquery name="categories">
        <querytext>
			select short_name as category_short_name, name as category_name
			from pinds_blog_categories
			where package_id = :package_id
        </querytext>
    </fullquery>

</queryset>
