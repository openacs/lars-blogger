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
  
  <a href="@archive_url@" title="Visit the archive for @blog_name@" class="action">Archive</a>
  <if @create_p@ true>
    <a href="@entry_add_url@" title="Add an entry to @blog_name@" class="action">Add entry</a>
  </if>
</p>
