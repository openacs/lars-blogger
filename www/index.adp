<master>
<property name="title">@page_title@</property>
<property name="header_stuff">@headerstuff;noquote@</property>
<property name="context">@context;noquote@</property>

<div class="lars_blogger_body">

  <if @display_bloggers_p@ eq 1>
    <if @bloggers:rowcount@ gt 0>
      <ul>
        <multiple name="bloggers">
          <li><a href="@package_url@user/@bloggers.screen_name@">@bloggers.screen_name@</a></li>
        </multiple>
      </ul>
    </if>
    <else>
      <i>#lars-blogger.No_bloggers_here#</i>
    </else>
    <if @create_p@ true>
      <if @user_has_blog_p@ true>
        <p>
          <b>&raquo;</b> <a href="@package_url@entry-edit" title="Add an entry to your weblog">#lars-blogger.Add_entry#</a><br>
        </p>
      </if>
      <else>
        <p>
          <b>&raquo;</b> <a href="@package_url@entry-edit" title="Start your weblog">#lars-blogger.Start_your_weblog#</a><br>
        </p>
      </else>
    </if>
    <if @admin_p@ true>
      <p>
        <b>&raquo;</b> <a href="@package_url@admin/" title="Visit administration pages">#lars-blogger.Administer#<a/>
      </p>
    </if>
  </if>
  <else>

    <div id="lars_blogger_left">
      <div class="lars_blogger_content_table">
        <include src="blog" type="@type@" archive_interval="@interval@" archive_date="@archive_date@" screen_name="@screen_name@" category_id="@category_id@" sw_category_id="@sw_category_id@" max_content_length="">
      </div>
    </div>

    <if @show_archive_p@ true>
      <div id="lars_blogger_right">
      <div class="lars_blogger_portlet">
        <h2>#lars-blogger.Archive#</h2>
        <include src="calendar" date="@date@" screen_name="@screen_name@">
        <include-optional src="blog-months" screen_name="@screen_name@">
          <include-output>
        </include-optional>
      </div>
      <if @display_categories@ eq 1 and @categories:rowcount@ gt 0>
        <div class="lars_blogger_portlet">
          <h2>#lars-blogger.Categories#</h2>
          <multiple name="categories">
            <a href="@package_url_with_extras@cat/@categories.category_short_name@">@categories.category_name@</a><br>
          </multiple>
        </div>
      </if>
      <if @sw_cats@ gt 0>
        <if @sw_categories:rowcount@ gt 0>
        <div class="lars_blogger_portlet">
         <multiple name="sw_categories">
           <h2>@sw_categories.tree_name@</h2>
           <group column="tree_id">
             <a href="@package_url_with_extras@swcat/@sw_categories.sw_category_id@">@sw_categories.sw_category_name@</a><br>
           </group>
         </multiple>
        </div>
      </if>
      </if>
      <if @create_p@ true>
        <div class="lars_blogger_portlet">
          <h2>#lars-blogger.Actions#</h2>
          <a href="@package_url@entry-edit" title="Add an entry to this blog">#lars-blogger.Add_entry#</a><br>
          <a href="@package_url@drafts" title="View draft entries">#lars-blogger.Draft_entries#<a/>
          <if @admin_p@ true>
            <br><a href="@package_url@admin/" title="Visit administration pages">#lars-blogger.Administer#</a>
          </if>
        </div>
      </if>
      <if @notification_chunk@ not nil>
        <div class="lars_blogger_portlet">
          <h2>#lars-blogger.Notifications#</h2>
          @notification_chunk;noquote@            
        </div>
      </if>
      <if @rss_file_url@ not nil>
        <div class="lars_blogger_portlet">
          <h2>#lars-blogger.Syndication_Feed#</h2>
          <a href="@rss_file_url@" title="RSS 2.0 feed"><img src="/resources/lars-blogger/xml.gif" width="36" height="14" border="0" alt="XML"></a>
        </div>
      </if>

      <include-optional src="/packages/lars-blogger/lib/last-n-comments" number_of_comments="10">
        <div class="lars_blogger_portlet">
          <h2>#lars-blogger.Recent_Comments#</h2>
          <include-output>
        </div>
      </include-optional>

      <include-optional src="/packages/lars-blogger/lib/blogroll">
        <div class="lars_blogger_portlet">
          <h2>#lars-blogger.Blogroll#</h2>
          <include-output>
        </div>
      </include-optional>

      <include-optional src="/packages/lars-blogger/lib/technorati">
	<div class="lars_blogger_portlet">
	  <h2>#lars-blogger.Technorati_Blogs#</h2>
	  <include-output>
        </div>
      </include-optional>

      </div>
    </if>
    <else>
      <if @notification_chunk@ not nil>
        <div class="lars_blogger_portlet">
          <h2>#lars-blogger.Notifications#</h2>
          @notification_chunk;noquote@            
        </div>
      </if>
    </else>

  </else>

</div>

