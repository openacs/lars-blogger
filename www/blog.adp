<multiple name="blog">
  <include src="@entry_chunk;literal@" &="blog" package_id="@package_id;literal@" screen_name="@screen_name;literal@" max_content_length="@max_content_length;literal@" unpublish_p="@unpublish_p;literal@" manageown_p="@manageown_p;literal@" />
</multiple>

<ul class="action-links">
  <if @blog_url@ not nil>
    <li><a href="@blog_url@" title="Visit @blog_name@ home">@blog_name@</a></li>
  </if>
  <if @create_p;literal@ true>
    <li><a href="@entry_add_url@" title="Add an entry to @blog_name@">#lars-blogger.Add_entry#</a></li>
  </if>
  <li><a href="@archive_url@" title="Visit the archive for @blog_name@">Archive</a></li>

</ul>

<if @rss_file_url@ not nil>
  <a href="@rss_file_url@" title="RSS 2.0 feed"><img src="/resources/lars-blogger/xml.gif" width="36" height="14" style="border:0" alt="XML"></a>
</if>
