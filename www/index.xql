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

</queryset>
