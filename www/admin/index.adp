<master>
<property name="title">@title@</property>

<p>
  These are your administrative options
</p>

<blockquote>
  <p>
    <a href="entry-edit"><img src="@arrow_url@" width="11" height="11" border="0" alt="Add new blog entry" title="Add new blog entry" /></a>
    <a href="entry-edit" title="Add new blog entry" class="action_link">Add new blog entry</a>
  </p>
  
  <p>
    <a href="drafts"><img src="@arrow_url@" width="11" height="11" border="0" alt="View draft entries" title="View draft entries" /></a>
    <a href="drafts" title="View draft entries" class="action_link">View draft entries</a>
  </p>
  
  <p>
    <a href="subscribers"><img src="@arrow_url@" width="11" height="11" border="0" alt="Show E-Mail subscribers" title="Show E-Mail subscribers" /></a>
    <a href="subscribers" title="Show E-Mail subscribers" class="action_link">Show E-Mail subscribers</a>
  </p>
  
  <p>
    <a href="@parameters_url@"><img src="@arrow_url@" width="11" height="11" border="0" alt="Set parameters" title="Set parameters" /></a>
    <a href="@parameters_url@" title="Set parameters" class="action_link">Set parameters</a>
  </p>

  <if @rss_feed_p@ false>
    <p>
      <a href="@rss_setup_url@"><img src="@arrow_url@" width="11" height="11" border="0" alt="Setup an RSS feed" title="Setup an RSS feed" /></a>
      <a href="@rss_setup_url@" title="Setup an RSS feed" class="action_link">Setup an RSS feed</a>
    </p>
  </if>
  <else>
    <p>
      <a href="@rss_manage_url@"><img src="@arrow_url@" width="11" height="11" border="0" alt="Manage your RSS feed" title="Manage your RSS feed" /></a>
      <a href="@rss_manage_url@" title="Manage your RSS feed" class="action_link">Manage your RSS feed</a>
    </p>
  </else>

</blockquote>
