<master>
<property name="title">@title@</property>

<p>
  These are your administrative options
</p>

<blockquote>
  <p>
    <b>&raquo;</b>
    <a href="../entry-edit" title="Add new blog entry" class="action_link">Add new blog entry</a>
  </p>
  
  <p>
    <b>&raquo;</b>
    <a href="../drafts" title="View draft entries" class="action_link">View draft entries</a>
  </p>
  
  <p>
    <b>&raquo;</b>
    <a href="subscribers" title="Show E-Mail subscribers" class="action_link">Show E-Mail subscribers</a>
  </p>
  
  <p>
    <b>&raquo;</b>
    <a href="@parameters_url@" title="Set parameters" class="action_link">Set parameters</a>
  </p>

  <if @instance_feed_p@ true>
    <p>
      <b>&raquo;</b>
      <a href="@rss_manage_url@" title="Manage your RSS feeds" class="action_link">Manage your RSS feeds</a> (<a href="@rss_file_url@">View instance feed XML</a>)
    </p>
  </if>

  <if @instance_feed_p@ false>
    <p>
      <b>&raquo;</b>
        <a href="@rss_setup_url@" title="Setup instance RSS feed" class="action_link">Setup instance RSS feed</a>
    </p>
  </if>

</blockquote>
