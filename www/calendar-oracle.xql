<?xml version="1.0"?>

<queryset>
    <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

  <fullquery name="all_entry_dates">
    <querytext>
      select to_char(entry_date, 'J') as entry_date_julian
      from   pinds_blog_entries
      where  package_id = :package_id
      and    draft_p = 'f'
      and    deleted_p = 'f'
      group  by to_char(entry_date, 'J')
    </querytext>
  </fullquery>


  <fullquery name="entry_dates">
    <querytext>
      select to_char(entry_date, 'J') as entry_date_julian
      from   pinds_blog_entries e,
             acs_objects o,
             users u
      where  package_id = :package_id
      and    o.object_id = e.entry_id
      and    u.user_id = o.creation_user
      and    u.screen_name = :screen_name
      and    draft_p = 'f'
      and    deleted_p = 'f'
      group  by to_char(entry_date, 'J')
    </querytext>
  </fullquery>
</queryset>
