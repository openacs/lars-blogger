<master>
<property name="doc(title)">@title;literal@</property>
<property name="context">@context;literal@</property>

<ul class="action-links">
  <li><a href="../entry-edit" title="Add new blog entry" class="action_link">#lars-blogger.Add_new_blog_entry#</a></li>
  <li><a href="bookmarklet" title="Generate a bookmarklet link" class="action_link">#lars-blogger.Bookmarklet#</a></li>
  <if @categories@ eq 1>
    <li>#lars-blogger.Deprecated# <a href="../category-edit" title="Categories"
class="action_link">#lars-blogger.lt_Old_style_Weblogger-o#</a>
  (<a href="migrate-categories" title="Migrate Categories"
         class="action_link">#lars-blogger.Migrate_Categories#</a>)
</li>
  </if>
  <li><a href="@category_map_url@" class="action_link">#lars-blogger.Site-Wide_Categories#</a>
  <li><a href="blogroll" title="View blogroll" class="action_link">#lars-blogger.Blogroll#</a></li>
  <li><a href="../drafts" title="View draft entries" class="action_link">#lars-blogger.View_draft_entries#</a></li>
  <li><a href="subscribers" title="Show E-Mail subscribers" class="action_link">#lars-blogger.lt_Show_E-Mail_subscribe#</a></li>
  <li><a href="@parameters_url@" title="Set parameters" class="action_link">#lars-blogger.Set_parameters#</a></li>
  <li><a href="@permission_url@" title="Change permissions"
  class="action_link">#lars-blogger.Change_permissions#</a></li>
  <if @instance_feed_p;literal@ true>
    <li><a href="@rss_manage_url@" title="Manage your RSS feeds" class="action_link">#lars-blogger.lt_Manage_your_RSS_feeds#</a> (<a href="@rss_file_url@">#lars-blogger.lt_View_instance_feed_XM#</a>)</li>
  </if>

  <if @instance_feed_p;literal@ false>
    <li><a href="@rss_setup_url@" title="Setup instance RSS feed" class="action_link">#lars-blogger.lt_Setup_instance_RSS_fe#</a></li>
  </if>
  <li><a href="@parameters_url@&section=Trackback" title="Configure Trackback" class="action_link">#lars-blogger.Configure_Trackback#</a> (<a href="../what-is-trackback">#lars-blogger.whats_trackback#</a>)</li>
  <li><a href="ping-urls" title="Manage your ping URLs" class="action_link">#lars-blogger.lt_Manage_your_ping_URLs#</a></li>
</ul>

