<link rel="stylesheet" type="text/css" href="@stylesheet_url@" />

<multiple name="blog">
  <table cellspacing="0" cellpadding="2" border="0" width="100%" class="lars_blogger_date_header"
    <tr>
      <th align="left">
        <a name="blog-date-@blog.entry_date@">@blog.entry_date_pretty@</a>
      </th>
      <if @blog.rownum@ eq 1>
        <th align="right">
            <a href="@entry_add_url@" title="Add an entry to @blog_name@">+</a>
            <if @blog_url@ not nil>
              <a href="@blog_url@" title="Visit @blog_name@ home">@blog_name@</a>
            </if>
        </th>
      </if>
    </tr>
  </table>
  <div class="lars_blogger_entry_group">
    <group column="entry_date">
      <include src="entry-chunk" &="blog" package_id="@package_id@" screen_name="@screen_name@" max_content_length="@max_content_length@">
    </group>
  </div>
</multiple>

<if @blog_url@ nil>
  <p>
    <b>&raquo;</b>
    <a href="@archive_url@" title="Visit the archive for @blog_name@" class="action_link">Archive</a><br />
  </p>
</if>    

<if @create_p@ true>
  <p>
    <b>&raquo;</b>
    <a href="@entry_add_url@" title="Add an entry to @blog_name@" class="action_link">Add entry</a>
  </p>
</if>

<if @rss_file_url@ not nil>
  <a href="@rss_file_url@" title="RSS 2.0 feed"><img src="/resources/lars-blogger/xml.gif" width="36" height="14" border="0" alt="XML"></a>
</if>
