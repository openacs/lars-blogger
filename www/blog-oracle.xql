<?xml version="1.0"?>

<queryset>
    <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

	<partialquery name="date_clause_archive">
		<querytext>
			trunc(entry_date, :archive_interval) = :archive_date
		</querytext>
	</partialquery>

	<partialquery name="date_clause_default">
		<querytext>
			entry_date > sysdate - 30
		</querytext>
	</partialquery>

    <fullquery name="blog">
        <querytext>
		    select entry_id,
		           to_char(entry_date, 'fmDayfm, Month fmDDfm, YYYY') as entry_date_pretty, 
		           to_char(entry_date, 'YYYY/MM/DD/') as entry_archive_url,
		           to_char(entry_date, 'YYYY-MM-DD') as entry_date,
		           title,
		           content,
                           content_format,
		           draft_p,
		           p.first_names as poster_first_names,
		           p.last_name as poster_last_name,
		           to_char(posted_date , 'HH24:MI') as posted_time_pretty,
		           (select count(gc.comment_id) 
		            from general_comments gc, cr_revisions cr 
		            where gc.object_id = entry_id
		            and   content_item.get_live_revision(gc.comment_id) = cr.revision_id) as num_comments
		    from   pinds_blog_entries e,
		           acs_objects o,
		           persons p
		    where  e.entry_id = o.object_id
		    and    p.person_id = o.creation_user
		    and    package_id = :package_id
		    and    $date_clause
		    and    draft_p = 'f'
		    and    deleted_p = 'f'
		    order  by entry_date desc, posted_date desc
        </querytext>
    </fullquery>

</queryset>
