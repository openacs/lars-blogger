<master>
<property name="title">@page_title@</property>
<if @rss_file_url@ not nil>
  <property name="header_stuff">
     <link rel="alternate" type="application/rss+xml" title="RSS" href="@rss_file_url@" />
     <link rel="stylesheet" type="text/css" href="@stylesheet_url@" />
  </property>
</if>
<else>
  <property name="header_stuff">
     <link rel="stylesheet" type="text/css" href="@stylesheet_url@" />
  </property>
</else>
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

  <if @write_p@ true>
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

<table width="100%">
  <tr>
    <td valign="top" align="center">
      <table class="lars_blogger_content_table" width="100%"><tr><td>
        <include src="blog" type="@type@" archive_interval="@interval@" archive_date="@archive_date@" screen_name="@screen_name@" category_id="@category_id@">
      </td></tr></table>
    </td>
    <td valign="top" align="center">
      
    </td>
    <td valign="top">

      <div class="lars_blogger_menu">
      <table width="100%" cellspacing="0" cellpadding="2" class="lars_blogger_menu_table">
        <tr>
          <th bgcolor="@header_background_color@">
            Archive
          </th>
        </tr>
        <tr>
          <td nowrap align="center">
            <include src="calendar" date="@date@" screen_name="@screen_name@">
          </td>
        </tr>
        <tr>
          <td height="16">
            <table><tr><td></td></tr></table>
          </td>
        </tr>

        <include-optional src="blog-months" screen_name="@screen_name@">
          <tr>
            <td nowrap align="center">
              <include-output>
            </td>
          </tr>
          <tr>
            <td height="16">
              <table><tr><td></td></tr></table>
            </td>
          </tr>
        </include-optional>

        <if @display_categories@ eq 1>
        <tr>
          <th>
            Categories
          </th>
        </tr>
        <tr>
          <td nowrap align="center">
            <multiple name="categories">
                <a href="@package_url_with_extras@cat/@categories.category_short_name@">@categories.category_name@</a><br>
            </multiple>
          </td>
        </tr>
        <tr>
          <td height="16">
            <table><tr><td></td></tr></table>
          </td>
        </tr>
        </if>


          <if @write_p@ true>
          <tr>
            <th bgcolor="@header_background_color@">
              Actions
            </th>
          </tr>
          <tr>
            <td align="center">
              <a href="@package_url@entry-edit" title="Add an entry to this blog">Add entry</a><br>
              <a href="@package_url@drafts" title="View draft entries">Draft entries<a/>
	      <if @admin_p@ true>
                <br><a href="@package_url@admin/" title="Visit administration pages">Administer<a/>
	      </if>
            </td>
          </tr>
          <tr>
            <td height="16">&nbsp;</td>
          </tr>
          </if>

        <if @notification_chunk@ not nil>
          <tr>
            <th bgcolor="@header_background_color@">
              Notifications
            </th>
          </tr>
          <tr>
            <td align="center">
              @notification_chunk;noquote@            
            </td>
          </tr>
          <tr>
            <td height="16">
              <table><tr><td></td></tr></table>
            </td>
          </tr>
        </if>

        <if @rss_file_url@ not nil>
          <tr>
            <th bgcolor="@header_background_color@" nowrap>
              Syndication Feed
            </th>
          </tr>
          <tr>
            <td nowrap align="center">
              <a href="@rss_file_url@" title="RSS 2.0 feed"><img src="/resources/lars-blogger/xml.gif" width="36" height="14" border="0" alt="XML"></a>
            </td>
          </tr>
        </if>
      </table>
      </div>

    </td>
  </tr>
</table>

</else>

</div>
