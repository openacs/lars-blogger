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
      <i>No bloggers here.</i>
    </else>
    <if @create_p@ true>
      <if @user_has_blog_p@ true>
        <p>
          <b>&raquo;</b> <a href="@package_url@entry-edit" title="Add an entry to your weblog">Add entry</a><br>
        </p>
      </if>
      <else>
        <p>
          <b>&raquo;</b> <a href="@package_url@entry-edit" title="Start your weblog">Start your weblog</a><br>
        </p>
      </else>
    </if>
    <if @admin_p@ true>
      <p>
        <b>&raquo;</b> <a href="@package_url@admin/" title="Visit administration pages">Administer<a/>
      </p>
    </if>
  </if>
  <else>

    <div id="lars_blogger_left">
      <div class="lars_blogger_content_table">
        <include src="blog" type="@type@" archive_interval="@interval@" archive_date="@archive_date@" screen_name="@screen_name@" category_id="@category_id@">
      </div>
    </div>

    <div id="lars_blogger_right">
      <div class="lars_blogger_portlet">
        <h2>Archive</h2>
        <include src="calendar" date="@date@" screen_name="@screen_name@">
        <include-optional src="blog-months" screen_name="@screen_name@">
          <include-output>
        </include-optional>
      </div>
      <if @display_categories@ eq 1>
        <div class="lars_blogger_portlet">
          <h2>Categories</h2>
          <multiple name="categories">
            <a href="@package_url_with_extras@cat/@categories.category_short_name@">@categories.category_name@</a><br>
          </multiple>
        </div>
      </if>
      <if @create_p@ true>
        <div class="lars_blogger_portlet">
          <h2>Actions</h2>
          <a href="@package_url@entry-edit" title="Add an entry to this blog">Add entry</a><br>
          <a href="@package_url@drafts" title="View draft entries">Draft entries<a/>
          <if @admin_p@ true>
            <br><a href="@package_url@admin/" title="Visit administration pages">Administer<a/>
          </if>
        </div>
      </if>
      <if @notification_chunk@ not nil>
        <div class="lars_blogger_portlet">
          <h2>Notifications</h2>
          @notification_chunk;noquote@            
        </div>
      </if>
      <if @rss_file_url@ not nil>
        <div class="lars_blogger_portlet">
          <h2>Syndication Feed</h2>
          <a href="@rss_file_url@" title="RSS 2.0 feed"><img src="/resources/lars-blogger/xml.gif" width="36" height="14" border="0" alt="XML"></a>
        </div>
      </if>
      <div class="lars_blogger_portlet">
        <h2>Recent Comments</h2>
        <include src="/packages/lars-blogger/lib/last-n-comments" number_of_comments="10">
      </div>

	<div class="lars_blogger_portlet">
	  <h2>Blogroll</h2>
	  <include src="/packages/lars-blogger/lib/blogroll">
	</div>

	<include-optional src="/packages/lars-blogger/lib/technorati">
	<div class="lars_blogger_portlet">
	  <h2>Technorati Blogs</h2>
	  <include-output>
        </div>
	</include-optional>

    </div>


  </else>


</div>
