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

	<partialquery name="user_filter_where_clause">
		<querytext>
            and o.creation_user = :blog_user_id
		</querytext>
	</partialquery>

	<partialquery name="sw_category_filter_where_clause">
		<querytext>
            and filt_com.category_id = :blog_sw_category_id
		</querytext>
	</partialquery>

	<partialquery name="sw_category_filter_join_clause">
		<querytext>
             , category_object_map filt_com
		</querytext>
	</partialquery>

	<partialquery name="sw_category_filter_join_where_clause">
		<querytext>
            and filt_com.object_id = e.entry_id
		</querytext>
	</partialquery>

    <fullquery name="blog">
<!-- In Oracle you can't use UNIQUE keyword on a query that
      contains a BLOB.  Therefore this ugly selfjoin:        -->
        <querytext>
 select x.*, y.content from (
    select unique entry_id,
           entry_date,
           to_char(entry_date, 'YYYY-MM-DD HH24:MI:SS')
             as entry_date_ansi,
           to_char(sysdate, 'YYYY-MM-DD HH24:MI:SS')
             as sysdate_ansi,
           e.title,  
           title_url,
           e.category_id,
           com.category_id as sw_category_id,
           content_format,
           draft_p,
           p.first_names as poster_first_names,
           p.last_name as poster_last_name,
           o.creation_user as user_id,
           (select count(gc.comment_id)
             from general_comments gc,
                  cr_revisions cr
            where gc.object_id = entry_id
		      and content_item.get_live_revision(gc.comment_id) =
                    cr.revision_id) as num_comments
    from   pinds_blog_entries e,
		           acs_objects o,
		           persons p,
                   category_object_map com
                   $sw_category_filter_join_clause
    where e.package_id = :package_id
    [ad_decode $date_clause "" "" "and    $date_clause"]
      and    draft_p = 'f'
      and    deleted_p = 'f'
      $user_filter_where_clause
      $sw_category_filter_where_clause
      $sw_category_filter_join_where_clause
      and p.person_id = o.creation_user
      and com.object_id (+) = e.entry_id
      and o.object_id = e.entry_id
) x, pinds_blog_entries y
where x.entry_id=y.entry_id
order by x.entry_date desc, x.entry_id, x.sw_category_id
        </querytext>
    </fullquery>

</queryset>
