<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.2</version></rdbms>

<fullquery name="metaWeblog.getRecentPosts.get_n_entries">
      <querytext>
        select entry_id,
               to_char(entry_date, 'YYYY-MM-DD') as entry_date,
               title,
			   c.name as category,
               content,
               to_char(posted_date , 'HH24:MI') as posted_time_pretty
		    from   pinds_blog_entries e left join pinds_blog_categories c 
                   using (category_id)
		    where  e.package_id = :package_id
		    and    draft_p = 'f'
		    and    deleted_p = 'f'
		    order  by entry_date desc, posted_date desc
            limit $num_posts
      </querytext>
</fullquery>

</queryset>
