<?xml version="1.0"?>

<queryset>

    <fullquery name="package_name">
        <querytext>
			select instance_name from apm_packages 
			where package_id = :package_id
        </querytext>
    </fullquery>

    <fullquery name="archive_date_month">
        <querytext>
			select to_date(:year || :month, 'YYYYMM') 
				as archive_date, 
			to_char(to_date(:year || :month, 'YYYYMM'), 'fmMonthfm, YYYY')
				as archive_date_pretty
			from dual
        </querytext>
    </fullquery>

    <fullquery name="archive_date_month_day">
        <querytext>
			select to_date(:year || :month || :day, 'YYYYMMDD') 
				as archive_date, 
			to_char(to_date(:year || :month || :day, 'YYYYMMDD'), 'Month fmDDfm, YYYY') 
				as archive_date_pretty
			from dual
        </querytext>
    </fullquery>

</queryset>
