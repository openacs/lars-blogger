<multiple name="blog">
  <if @blog.new_date_p@ eq "t">
    <table cellspacing="0" cellpadding="2" border="0" width="100%">
      <tr>
        <th bgcolor="#e0d0b0" align=left>
          <b><a name="blog-date-@blog.entry_date@">@blog.entry_date_pretty@</a></b>
        </th>
      </tr>
    </table>
  <div style="padding-bottom:14px;">
  </if>
  <else>
    <div style="border-top:1px dashed #3366cc;padding-bottom:14px;">
  </else>
  <include src="entry-chunk" &="blog">
  </div>
</multiple>

<a href="@archive_url@"><img src="@arrow_url@" width="11" height="11" border="0" alt="Archive"></a>
<a href="@archive_url@" class="action_link">Archive</a>
<if @admin_p@ eq 1>
  <br>
  <a href="@entry_add_url@"><img src="@arrow_url@" width="11" height="11" border="0" alt="Add entry"></a>
  <a href="@entry_add_url@" class="action_link">Add entry</a>
</if>

