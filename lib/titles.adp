<comment>
  This include is inteded to be used with 
    lars_blog_get_as_string -display_template /package/lars-blogger/lib/titles.adp
  see that tcl function for more docs.
</comment>
  <if @blog:rowcount@ gt 0>
    <ul>
      <multiple name="blog">
        <li><a href="@blog.permalink_url@">@blog.title@</a></li>
      </multiple>
    </ul>
  </if>
