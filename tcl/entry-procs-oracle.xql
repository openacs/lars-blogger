<?xml version="1.0"?>

<queryset>
    <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

    <fullquery name="lars_blogger::entry::new.entry_add">
        <querytext>
                        begin
                            :1 := pinds_blog_entry.new (
                                entry_id => :entry_id,
                                package_id => :package_id,
                                title => :title,
                                title_url => :title_url,
                                content => :content,
                                content_format => :content_format,
                                entry_date => nvl(to_date(:entry_date, 'YYYY-MM-DD'), sysdate),
                                draft_p => :draft_p,
                                creation_user => :creation_user,
                                creation_ip => :creation_ip
                            );
                        end;
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
		           to_char(b.entry_date , 'YYYY-MM-DD ')||to_char(b.posted_date , 'HH24:MI:SS') as entry_date_ansi,
                           to_char(sysdate,'YYYY-MM-DD HH24:MI:SS') as sysdate_ansi,
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

    <fullquery name="lars_blogger::entry::publish.update_entry">
        <querytext>
		    update pinds_blog_entries
		    set    entry_date = trunc(sysdate),
		           draft_p = 'f',
		           posted_date = sysdate
		    where  entry_id = :entry_id
        </querytext>
    </fullquery>

    <fullquery name="lars_blogger::entry::get_comments.get_comments">
	<querytext>
      
             select g.comment_id,
                    r.title,
                    r.mime_type,
                    o.creation_user,
                    acs_object.name(o.creation_user) as author,
                    to_char(o.creation_date, 'MM-DD-YYYY') as pretty_date,
                    to_char(o.creation_date, 'Month DD, YYYY HH12:MI PM') as pretty_date2,
		    case when tb.comment_id is not null then 't' else 'f' end as trackback_p,
		    tb.tb_url as trackback_url,
		    nvl(tb.name, tb.tb_url) as trackback_name
               from general_comments g, 
                    trackback_pings tb,
                    cr_revisions r,
	            cr_items ci,
                    acs_objects o
              where g.object_id = :entry_id 
		and r.revision_id = ci.live_revision
	        and ci.item_id = g.comment_id
                and o.object_id = g.comment_id
                and tb.comment_id (+) = g.comment_id
              order by o.creation_date
		
	</querytext>
    </fullquery>

</queryset>

