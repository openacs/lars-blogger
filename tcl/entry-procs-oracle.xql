<?xml version="1.0"?>

<queryset>
    <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

    <fullquery name="lars_blogger::entry::get.select_entry">
        <querytext>
		    select b.entry_id,  
                           b.title, 
                           b.content, 
                           b.content_format, 
                           b.draft_p, 
                           to_char(b.entry_date, 'YYYY-MM-DD') as entry_date,
		           to_char(b.entry_date, 'fmDayfm, Month fmDDfm, YYYY') as entry_date_pretty, 
        		   p.first_names as poster_first_names,
		           p.last_name as poster_last_name,
		           to_char(b.posted_date , 'HH24:MI') as posted_time_pretty,
                           b.package_id,
		           (select count(gc.comment_id) 
		            from general_comments gc, cr_revisions cr 
		            where gc.object_id = entry_id
		            and content_item.get_live_revision(gc.comment_id) = cr.revision_id) as num_comments
		    from   pinds_blog_entries b,
                           acs_objects o,
                           persons p
		    where  b.entry_id = :entry_id
                    and    o.object_id = b.entry_id
                    and    p.person_id = o.creation_user
        </querytext>
    </fullquery>

</queryset>
