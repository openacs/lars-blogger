<?xml version="1.0"?>

<queryset>
    <rdbms><type>postgresql</type><version>7.1</version></rdbms>

  <fullquery name="all_entry_dates">
    <querytext>
      select to_char(entry_date, 'J') as entry_date_julian
      from   pinds_blog_entries
      where  package_id = :package_id
      and    draft_p = 'f'
      and    deleted_p = 'f'
      group  by entry_date_julian
    </querytext>
  </fullquery>


  <fullquery name="entry_dates">
    <querytext>
      select to_char(entry_date, 'J') as entry_date_julian
      from   pinds_blog_entries e join
             acs_objects o on (o.object_id = e.entry_id) join
             users u on (u.user_id = o.creation_user)
      where  package_id = :package_id
      and    screen_name = :screen_name
      and    draft_p = 'f'
      and    deleted_p = 'f'
      group  by entry_date_julian
    </querytext>
  </fullquery>
</queryset>
