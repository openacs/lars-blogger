<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="blogger.getRecentPosts.get_n_entries">
      <querytext>
        select * from 
         (select entry_id,
                 to_char(entry_date, 'YYYY-MM-DD HH24:MI:SS') as entry_date_ansi,
                 content
          from   pinds_blog_entries
          and    package_id = :package_id
          and    draft_p = 'f'
          and    deleted_p = 'f'
          order  by entry_date desc, entry_id desc
        ) where rownum <= :numberOfPosts
      </querytext>
</fullquery>

</queryset>
