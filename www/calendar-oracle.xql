<?xml version="1.0"?>

<queryset>
    <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

  <fullquery name="entry_dates">
    <querytext>
      select to_char(entry_date, 'J') as entry_date_julian
      from   pinds_blog_entries
      where  package_id = :package_id
      and    draft_p = 'f'
      and    deleted_p = 'f'
      group  by to_char(entry_date, 'J')
    </querytext>
  </fullquery>
</queryset>
