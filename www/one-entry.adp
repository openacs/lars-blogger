<master>
<property name="title">@page_title@</property>
<property name="context">@context@</property>   

<table cellspacing="0" cellpadding="2" border="0" width="100%">
  <tr>
    <th bgcolor="@header_background_color@" align=left>
      <b><a name="blog-date-@blog.entry_date@">@blog.entry_date_pretty@</a></b>
    </th>
  </tr>
</table>

<include src="entry-chunk" &="blog" show_comments_p="t">
