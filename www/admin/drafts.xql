<?xml version="1.0"?>

<queryset>

    <fullquery name="draft_entries">
        <querytext>
		    select entry_id,
		           to_char(entry_date, 'YYYY-MM-DD') as entry_date_pretty, 
		           title,
		           content,
		           '' as edit_url,
		           '' as delete_url,
		           '' as preview_url
		    from   pinds_blog_entries
		    where  package_id = :package_id
		    and    draft_p = 't'
		    and    deleted_p = 'f'
		    order  by entry_date desc, posted_date desc
        </querytext>
    </fullquery>

</queryset>
