<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.2</version></rdbms>

<fullquery name="blogger.getRecentPosts.get_n_entries">
      <querytext>
        select entry_id,
               to_char(entry_date, 'YYYY-MM-DD HH24:MI:SS') as entry_date_ansi,
               content
    	       from   pinds_blog_entries 
    	       where  package_id = :package_id
    	       and    draft_p = 'f'
    	       and    deleted_p = 'f'
    	       order  by entry_date desc, entry_id desc
            limit $numberOfPosts
      </querytext>
</fullquery>

</queryset>
