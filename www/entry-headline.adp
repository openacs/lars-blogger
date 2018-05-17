<!--
  <include src="/packages/trackback/lib/trackback-chunk" url="@blog.permalink_url;literal@" blog_url="@package_url;literal@" title="@blog.title;literal@" object_id="@blog.entry_id;literal@">
-->

<div class="lars_blogger_entry">

  <div>
    <if @blog.title@ not nil>
      <if @perma_p;literal@ true>
        <b>@blog.title;noquote@</b>
      </if>
      <else>
        <a href="@blog.permalink_url@" title="Permanent URL for this entry"><b>@blog.title;noquote@</b></a>
      </else>
    </if>
    <br> @blog.posted_time_pretty@ 
  </div> 



</div>

<if @comments:rowcount@ not nil>
  <multiple name="comments">
    <h3 class="lars_blogger_comment_title">@comments.title@</h3>
    <p class="lars_blogger_comment_text">@comments.content;noquote@</p>
    <p><if @comments.trackback_p;literal@ false>by @comments.author@</if><else>Trackback from <a href="@comments.trackback_url@" title="@comments.trackback_name@">@comments.trackback_name@</a></else> on @comments.pretty_date@</p>
  </multiple>
  <center><a href="@blog.comment_add_url@" title="Comment on this entry">Add comment</a></center>
</if>

