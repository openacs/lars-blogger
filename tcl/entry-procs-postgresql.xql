<?xml version="1.0"?>

<queryset>
    <rdbms><type>postgresql</type><version>7.1</version></rdbms>

    <fullquery name="lars_blogger::entry::new.entry_add">
        <querytext>
	        select pinds_blog_entry__new (
            		:entry_id,
  	          	:package_id,
        	    	:title,
                	:title_url,
                        :category_id,
	            	:content,
        	    	:content_format,
            		coalesce(to_date(:entry_date, 'YYYY-MM-DD'), current_timestamp),
	            	:draft_p,
        	    	:creation_user,
            		:creation_ip
        	)
        </querytext>
    </fullquery>

    <fullquery name="lars_blogger::entry::get.select_entry">
        <querytext>
            select b.entry_id,  
                   b.title, 
                   b.title_url, 
                   b.category_id, 
                   b.content, 
                   b.content_format, 
                   b.draft_p, 
                   o.creation_user as user_id,
                   to_char(b.entry_date, 'YYYY-MM-DD') as entry_date,
                   to_char(b.entry_date, 'fmDayfm, fmMonthfm fmDDfm, YYYY') as entry_date_pretty, 
                   p.first_names as poster_first_names,
                   p.last_name as poster_last_name,
                   to_char(b.posted_date , 'HH24:MI') as posted_time_pretty,
                   b.package_id,
                   (select count(gc.comment_id) 
                    from general_comments gc, cr_revisions cr 
                    where gc.object_id = entry_id
                    and   content_item__get_live_revision(gc.comment_id) = cr.revision_id) as num_comments
            from   pinds_blog_entries b,
                   acs_objects o,
                   persons p
            where  b.entry_id = :entry_id
            and    o.object_id = b.entry_id
            and    p.person_id = o.creation_user
            and    b.deleted_p = 'f'
        </querytext>
    </fullquery>

    <fullquery name="lars_blogger::entry::publish.update_entry">
        <querytext>
		    update pinds_blog_entries
		    set    entry_date = date_trunc('day', current_timestamp),
		           draft_p = 'f',
		           posted_date = current_timestamp
		    where  entry_id = :entry_id
        </querytext>
    </fullquery>

    <fullquery name="lars_blogger::entry::get_comments.get_comments">
	<querytext>
      
             select g.comment_id,
		    r.content,
                    r.title,
                    r.mime_type,
                    o.creation_user,
                    acs_object__name(o.creation_user) as author,
                    to_char(o.creation_date, 'MM-DD-YYYY') as pretty_date,
                    to_char(o.creation_date, 'Month DD, YYYY HH12:MI PM') as pretty_date2,
		    case when tb.comment_id is not null then 't' else 'f' end as trackback_p,
		    tb.tb_url as trackback_url,
		    coalesce(tb.name, tb.tb_url) as trackback_name
               from general_comments g left join trackback_pings tb on g.comment_id=tb.comment_id,
                    cr_revisions r,
	            cr_items ci,
                    acs_objects o
              where g.object_id = :entry_id
		and r.revision_id = ci.live_revision
	        and ci.item_id=g.comment_id 
                and o.object_id = g.comment_id
              order by o.creation_date
		
	</querytext>
    </fullquery>

</queryset>
