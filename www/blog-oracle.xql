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
			entry_date > sysdate - :num_days
		</querytext>
	</partialquery>

    <fullquery name="all_blogs">
        <querytext>
		    select entry_id,
		           to_char(entry_date, 'YYYY-MM-DD HH24:MI:SS') as entry_date_ansi,
		           title,
                           title_url,
			   category_id,
		           content,
                           content_format,
		           draft_p,
		           p.first_names as poster_first_names,
		           p.last_name as poster_last_name,
			   o.creation_user as user_id,
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
		    [ad_decode $date_clause "" "" "and    $date_clause"]
		    and    draft_p = 'f'
		    and    deleted_p = 'f'
                    [ad_decode $limit "" "" "and    rownum <= $limit"]
		    order  by entry_date desc
        </querytext>
    </fullquery>

    <fullquery name="blog">
        <querytext>
		    select entry_id,
		           to_char(entry_date, 'YYYY-MM-DD HH24:MI:SS') as entry_date_ansi,
		           title,
                           title_url,
			   category_id,
		           content,
                           content_format,
		           draft_p,
		           p.first_names as poster_first_names,
		           p.last_name as poster_last_name,
			   o.creation_user as user_id,
		           (select count(gc.comment_id) 
		            from general_comments gc, cr_revisions cr 
		            where gc.object_id = entry_id
		            and   content_item.get_live_revision(gc.comment_id) = cr.revision_id) as num_comments
		    from   pinds_blog_entries e,
		           acs_objects o,
		           persons p
		    where  e.entry_id = o.object_id
		    and    p.person_id = o.creation_user
                    and    o.creation_user = :blog_user_id
		    and    package_id = :package_id
		    [ad_decode $date_clause "" "" "and    $date_clause"]
		    and    draft_p = 'f'
		    and    deleted_p = 'f'
                    [ad_decode $limit "" "" "and    rownum <= $limit"]
		    order  by entry_date desc
        </querytext>
    </fullquery>

</queryset>
