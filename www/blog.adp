<multiple name="blog">
  <table cellspacing="0" cellpadding="2" border="0" width="100%">
    <tr>
      <th bgcolor="@header_background_color@" align="left">
        <b><a name="blog-date-@blog.entry_date@"><font size="-1">@blog.entry_date_pretty@</font></a></b>
      </th>
      <if @blog.rownum@ eq 1>
        <th bgcolor="@header_background_color@"  align="right">
          <font size="-1">
            <a href="@entry_add_url@" title="Add an entry to @blog_name@">+</a>
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
      <include src="entry-chunk" &="blog" package_id="@package_id@" write_p="@write_p@" screen_name="@screen_name@">
    </div>
  </group>
</multiple>

<p>
  <if @blog_url@ not nil>
    <b>&raquo;</b>
    <a href="@blog_url@" title="Visit @blog_name@ home"
       class="action_link">@blog_name@</a><br />
  </if>
  
  <b>&raquo;</b>
  <a href="@archive_url@" title="Visit the archive for @blog_name@" class="action_link">Archive</a><br />
  
  <if @write_p@ gt 0>
    <b>&raquo;</b>
    <a href="@entry_add_url@" title="Add an entry to @blog_name@" class="action_link">Add entry</a>
  </if>
</p>
