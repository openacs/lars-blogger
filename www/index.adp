<master>
<property name="title">@page_title@</property>
<if @rss_file_url@ not nil>
  <property name="header_stuff"><link rel="alternate" type="application/rss+xml" title="RSS" href="@rss_file_url@" /></property>
</if>
<property name="context_bar">@context_bar@</property>

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
    <p>
      <b>&raquo;</b> <a href="@package_url@entry-edit" title="Add an entry to your weblog, or start a new weblog">Add entry or start a new weblog</a><br>
    </p>
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
    <td valign="top">
      <include src="blog" type="@type@" archive_interval="@interval@" archive_date="@archive_date@" screen_name="@screen_name@">
    </td>
    <td valign="top">

      <table width="100%" cellspacing="0" cellpadding="2">
        <tr>
          <th bgcolor="@header_background_color@">
            Calendar
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
              @notification_chunk@            
            </td>
          </tr>
          <tr>
            <td height="16">
              <table><tr><td></td></tr></table>
            </td>
          </tr>
        </if>

        <include-optional src="blog-months" screen_name="@screen_name@">
          <tr>
            <th bgcolor="@header_background_color@">
              Archive
            </th>
          </tr>
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

        <if @rss_file_url@ not nil>
          <tr>
            <th bgcolor="@header_background_color@" nowrap>
              Syndication Feed
            </th>
          </tr>
          <tr>
            <td nowrap align="center">
              <a href="@rss_file_url@" title="Link to the RSS feed">RSS 1.0/RDF/XML</a>
            </td>
          </tr>
        </if>
      </table>

    </td>
  </tr>
</table>

</else>
