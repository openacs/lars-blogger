<?xml version="1.0"?>

<queryset>
    <rdbms><type>postgresql</type><version>7.1</version></rdbms>

    <fullquery name="lars_blog_entry_add.entry_add">
        <querytext>
			select pinds_blog_entry__new (
            	:entry_id,
            	:package_id,
            	:title,
            	:content,
            	:content_format,
            	to_date(:entry_date, 'YYYY-MM-DD'),
            	:draft_p,
            	:creation_user,
            	:creation_ip
        	)
        </querytext>
    </fullquery>

</queryset>
