<master>
<property name="title">@title;noquote@</property>
<property name="context">@context;noquote@</property>

<ul class="action-links">
  <li><a href="../entry-edit" title="Add new blog entry" class="action_link">Add new blog entry</a></li>
  <li><a href="bookmarklet" title="Generate a bookmarklet link" class="action_link">Bookmarklet</a></li>
  <if @categories@ eq 1>
    <li><a href="../category-edit" title="Categories" class="action_link">Categories</a></li>
  </if>
  <li><a href="@category_map_url@" class="action_link">Site-Wide Categories</a>
  <li><a href="blogroll" title="View blogroll" class="action_link">Blogroll</a></li>
  <li><a href="../drafts" title="View draft entries" class="action_link">View draft entries</a></li>
  <li><a href="subscribers" title="Show E-Mail subscribers" class="action_link">Show E-Mail subscribers</a></li>
  <li><a href="@parameters_url@" title="Set parameters" class="action_link">Set parameters</a></li>
  <if @instance_feed_p@ true>
    <li><a href="@rss_manage_url@" title="Manage your RSS feeds" class="action_link">Manage your RSS feeds</a> (<a href="@rss_file_url@">View instance feed XML</a>)</li>
  </if>

  <if @instance_feed_p@ false>
    <li><a href="@rss_setup_url@" title="Setup instance RSS feed" class="action_link">Setup instance RSS feed</a></li>
  </if>
  <li><a href="@parameters_url@&section=Trackback" title="Configure Trackback" class="action_link">Configure Trackback</a> (<a href="../what-is-trackback">what's trackback?</a>)</li>
  <li><a href="ping-urls" title="Manage your ping URLs" class="action_link">Manage your ping URLs</a></li>
</ul>
