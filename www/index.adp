<master>
<property name="title">@page_title;noquote@</property>
<if @rss_file_url@ not nil>
  <property name="header_stuff"><link rel="alternate" type="application/rss+xml" title="RSS" href="@rss_file_url;noquote@" /></property>
</if>
<property name="context_bar">@context_bar;noquote@</property>

<table width="100%">
  <tr>
    <td valign="top">
      <include src="blog" type="@type;noquote@" archive_interval="@interval;noquote@" archive_date="@archive_date;noquote@">
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
            <include src="calendar" date="@date;noquote@">
          </td>
        </tr>
        <tr>
          <td height="16">
            <table><tr><td></td></tr></table>
          </td>
        </tr>

        <if @admin_p@ true>
          <tr>
            <th bgcolor="@header_background_color@">
              Actions
            </th>
          </tr>
          <tr>
            <td align="center">
              <a href="admin/entry-edit" title="Add an entry to this blog">Add entry</a><br>
              <a href="admin/drafts" title="View draft entries">Draft entries<a/><br>
              <a href="admin/" title="Visit administration pages">Administer<a/>
            </td>
          </tr>
          <tr>
            <td height="16">
              <table><tr><td></td></tr></table>
            </td>
          </tr>
        </if>

        <if @notification_chunk;noquote@ not nil>
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

        <include-optional src="blog-months">
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
            <td nowrap>
              <a href="@rss_file_url@" title="Link to the RSS feed">RSS 1.0/RDF/XML</a>
            </td>
          </tr>
        </if>
      </table>

    </td>
  </tr>
</table>

