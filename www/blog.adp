<link rel="stylesheet" type="text/css" href="@stylesheet_url@" />

<multiple name="blog">
  <include src="entry-chunk" &="blog" package_id="@package_id@" screen_name="@screen_name@">
</multiple>

<p>
  <if @blog_url@ not nil>
    <b>&raquo;</b>
    <a href="@blog_url@" title="Visit @blog_name@ home"
       class="action_link">@blog_name@</a><br />
  </if>
  
  <b>&raquo;</b>
  <a href="@archive_url@" title="Visit the archive for @blog_name@" class="action_link">Archive</a><br />
  
  <if @create_p@ true>
    <b>&raquo;</b>
    <a href="@entry_add_url@" title="Add an entry to @blog_name@" class="action_link">Add entry</a>
  </if>
</p>
