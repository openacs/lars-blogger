<include src="/packages/trackback/lib/trackback-chunk" url="@blog.entry_archive_url@" blog_url="@package_url@" title="@blog.title@" object_id="@blog.entry_id@">
<div class="lars_blogger_entry">

<div class="lars_blogger_title">
<if @blog.title_url@ not nil>
    <a href="@blog.title_url@"><b><if @blog.title@ not nil>@blog.title@</if><else>@blog.title_url@</else></b></a>

    <if @blog.title_url_base@ not nil>
      &nbsp;&nbsp;<span class="lars_blogger_title_url">[@blog.title_url_base@]</span>
    </if>
  </p>
</if>
<else>
  <if @blog.title@ not nil>
    <p><b>@blog.title@</b></p>
  </if>
</else>
</div> 

<div class="lars_blogger_text">
   @blog.content;noquote@
</div>

<p class="lars_blogger_poster">
  @blog.posted_time_pretty@ 
  <if @show_poster_p@ true>
    by @blog.poster_first_names@ @blog.poster_last_name@
  </if>
  <if @display_categories@ and @blog.category_id@ gt 0>
    in <a href="@category_url@" title="@blog.category_name@">@blog.category_name@</a>
  </if>
  |

  <a href="@blog.entry_archive_url@" title="Permanent URL for this entry">Permalink</a>
  | <a href="@blog.comments_view_url@" title="View comments on this entry">Comments (@blog.num_comments@)</a>
  <if @blog.write_p@ true>
    | <a href="@blog.edit_url@">Edit</a>
    <if @blog.draft_p@ true>
      | <a href="@blog.publish_url@">Publish</a>
    </if>
    <else>
      | <a href="@blog.revoke_url@">Draft</a>
    </else>
  </if>
</p>

</div>


<if @comments:rowcount@ not nil>
<multiple name="comments">
<h3 class="lars_blogger_comment_title">@comments.title@</h3>
<p class="lars_blogger_comment_text">@comments.content@</p>
<p><if @comments.trackback_p@ eq "f">by @comments.author@</if><else>Trackback from <a href="@comments.trackback_url@" title="@comments.trackback_name@">@comments.trackback_name@</a></else> on @comments.pretty_date@</p>
</multiple>
  <center><a href="@blog.comment_add_url@" title="Comment on this entry">Add comment</a></center>
</if>
