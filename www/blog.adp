<link rel="stylesheet" type="text/css" href="@stylesheet_url@" />

<multiple name="blog">
  <include src="entry-chunk" &="blog" package_id="@package_id@" screen_name="@screen_name@">
</multiple>

<ul class="action-links">
  <if @blog_url@ not nil>
    <li><a href="@blog_url@" title="Visit @blog_name@ home">@blog_name@</a></li>
  </if>
  <li><a href="@archive_url@" title="Visit the archive for @blog_name@">Archive</a></li>
  <if @create_p@ true>
    <li><a href="@entry_add_url@" title="Add an entry to @blog_name@">Add entry</a></li>
  </if>
</ul>

<if @rss_file_url@ not nil>
  <a href="@rss_file_url@" title="RSS 2.0 feed"><img src="/resources/lars-blogger/xml.gif" width="36" height="14" border="0" alt="XML"></a>
</if>
