<multiple name="blog">
  <table cellspacing="0" cellpadding="2" border="0" width="100%">
    <tr>
      <th bgcolor="@header_background_color@" align="left">
        <b><a name="blog-date-@blog.entry_date@">@blog.entry_date_pretty@</a></b>
      </th>
      <if @blog.rownum@ eq 1>
        <th bgcolor="@header_background_color@"  align="right">
          <font size="-1">
            <if @admin_p@ eq 1>
              <a href="@entry_add_url@" title="Add an entry to @blog_name@">+</a>
            </if>
            <if @blog_url@ not nil>
              <a href="@blog_url@" title="Visit @blog_name@ home">@blog_name@</a>
            </if>
         </font>
        </th>
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
    <a href="@blog_url@"><img src="@arrow_url@" width="11" height="11" border="0" alt="Visit @blog_name@ home" title="Visit @blog_name@ home" /></a>
    <a href="@blog_url@" title="Visit @blog_name@ home"
       class="action_link">@blog_name@</a><br />
  </if>
  
  <a href="@archive_url@"><img src="@arrow_url@" width="11" height="11" border="0" alt="Visit the archive for @blog_name@" title="Visit the archive for @blog_name@" /></a>
  <a href="@archive_url@" title="Visit the archive for @blog_name@" class="action_link">Archive</a><br />

  <if @admin_p@ eq 1>
    <a href="@entry_add_url@"><img src="@arrow_url@" width="11" height="11" border="0" alt="Add an entry to @blog_name@" title="Add an entry to @blog_name@" /></a>
    <a href="@entry_add_url@" title="Add an entry to @blog_name@" class="action_link">Add entry</a>
  </if>

  <if @notification_chunk@ not nil>
    <p>@notification_chunk@</p>
  </if>
</p>
