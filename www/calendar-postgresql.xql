<?xml version="1.0"?>

<queryset>
    <rdbms><type>postgresql</type><version>7.1</version></rdbms>

  <fullquery name="entry_dates">
    <querytext>
      select to_char(entry_date, 'J') as entry_date_julian
      from   pinds_blog_entries
      where  package_id = :package_id
      and    draft_p = 'f'
      and    deleted_p = 'f'
      group  by entry_date_julian
    </querytext>
  </fullquery>
</queryset>
