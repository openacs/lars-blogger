<?xml version="1.0"?>

<queryset>
  <fullquery name="entry_dates">
    <querytext>
      select distinct to_char(entry_date, 'J') as entry_date_julian
      from   pinds_blog_entries
      where  package_id = :package_id
      and    draft_p = 'f'
      and    deleted_p = 'f'
    </querytext>
  </fullquery>
</queryset>
