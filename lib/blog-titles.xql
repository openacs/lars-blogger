<?xml version="1.0"?>
<!DOCTYPE queryset PUBLIC "-//OpenACS//DTD XQL 1.0//EN"
"http://www.thecodemill.biz/repository/xql.dtd">
<!-- packages/lars-blogger/lib/blog-titles.xql -->
<!-- @author sussdorff aolserver (sussdorff@ipxserver.de) -->
<!-- @creation-date 2005-02-21 -->
<!-- @arch-tag: 23e4043a-5394-4299-8841-bc9a94a11281 -->
<!-- @cvs-id $Id$ -->

<queryset>
  <fullquery name="blog-titles">
    <querytext>
      select entry_id, title,title_url from pinds_blog_entries 
      where package_id = :package_id       
      [ad_decode $date_clause "" "" "and    $date_clause"]
      and    draft_p = 'f'
      and    deleted_p = 'f' 
      order by entry_date desc
      </querytext>
    </fullquery>

</queryset>