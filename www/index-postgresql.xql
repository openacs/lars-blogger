<?xml version="1.0"?>

<queryset>
    <rdbms><type>postgresql</type><version>7.1</version></rdbms>

    <fullquery name="archive_date_year">
        <querytext>
			select to_date(:year, 'YYYY') 
				as archive_date, 
			to_char(to_date(:year, 'YYYY'), 'YYYY')
				as archive_date_pretty
			from dual
        </querytext>
    </fullquery>

    <fullquery name="bloggers">
        <querytext>
		    select distinct u.screen_name, u.user_id
		    from   pinds_blog_entries e join 
		           acs_objects o on (o.object_id = e.entry_id) join 
		           users u on (u.user_id = o.creation_user)
		    where  e.package_id = :package_id
                    and    u.screen_name != ''
        </querytext>
    </fullquery>

</queryset>
