<master>
<property name="header_stuff">
     <link rel="stylesheet" type="text/css" href="@stylesheet_url@" />
</property>

<property name="title">@page_title@</property>
<property name="context_bar">@context_bar;noquote@</property>   

<div class="lars_blogger_body">

<table cellspacing="0" cellpadding="2" border="0" width="100%" class="lars_blogger_date_header">
  <tr>
    <th bgcolor="@header_background_color@" align=left>
      <b><a name="blog-date-@blog.entry_date@">@blog.entry_date_pretty@</a></b>
    </th>
  </tr>
</table>

<include src="entry-chunk" &="blog" show_comments_p="t" screen_name="@screen_name@">

</div>
