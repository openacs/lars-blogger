<multiple name="blog">
  <table cellspacing="0" cellpadding="2" border="0" width="100%">
    <tr>
      <th bgcolor="@header_background_color@" align="left">
        <b><a name="blog-date-@blog.entry_date@"><font size="-1">@blog.entry_date_pretty@</font></a></b>
      </th>
      <if @blog.rownum@ eq 1>
        <if @blog_url@ not nil>
          <th bgcolor="@header_background_color@"  align="right">
            <font size="-1"><a href="@blog_url@">@blog_name@</a></font>
          </th>
        </if>
      </if>
    </tr>
  </table>
  <group column="entry_date">
    <div style="border-bottom:1px dashed #3366cc;">
      <include src="entry-chunk" &="blog" package_id="@package_id@">
    </div>
  </group>
</multiple>

<p>
  <if @blog_url@ not nil>
    <a href="@blog_url@"><img src="@arrow_url@" width="11" height="11" border="0" alt="@blog_name@"></a>
    <a href="@blog_url@" class="action_link">@blog_name@</a><br>
  </if>
  
  <a href="@archive_url@"><img src="@arrow_url@" width="11" height="11" border="0" alt="Archive"></a>
  <a href="@archive_url@" class="action_link">Archive</a><br>
  
  <if @admin_p@ eq 1>
    <a href="@entry_add_url@"><img src="@arrow_url@" width="11" height="11" border="0" alt="Add entry"></a>
    <a href="@entry_add_url@" class="action_link">Add entry</a>
  </if>
</p>