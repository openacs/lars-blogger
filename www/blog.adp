<multiple name="blog">
  <table cellspacing="0" cellpadding="2" border="0" width="100%">
    <tr>
      <th bgcolor="@header_background_color@" align=left>
        <b><a name="blog-date-@blog.entry_date@">@blog.entry_date_pretty@</a></b>
      </th>
    </tr>
  </table>
  <group column="entry_date">
    <div style="border-bottom:1px dashed #3366cc; padding-bottom:14px;">
      <include src="entry-chunk" &="blog">
    </div>
  </group>
</multiple>

<a href="@archive_url@"><img src="@arrow_url@" width="11" height="11" border="0" alt="Archive"></a>
<a href="@archive_url@" class="action_link">Archive</a>
<if @admin_p@ eq 1>
  <br>
  <a href="@entry_add_url@"><img src="@arrow_url@" width="11" height="11" border="0" alt="Add entry"></a>
  <a href="@entry_add_url@" class="action_link">Add entry</a>
</if>

