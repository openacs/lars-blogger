<multiple name="blog">
  <if @blog.new_date_p@ eq "t">
    <table cellspacing="0" cellpadding="2" border="0" width="100%">
      <tr>
        <th bgcolor="#e0d0b0" align=left>
          <b><a name="blog-date-@blog.entry_date@">@blog.entry_date_pretty@</a></b>
          <if @admin_p@ eq 1>
            <font size="-1">
              (<a href="@entry_add_url@">Add entry</a>)
            </font>
          </if>
        </th>
      </tr>
    </table>
  <div style="padding-bottom:14px;">
  </if>
  <else>
    <div style="border-top:1px dashed #3366cc;padding-bottom:14px;">
  </else>
  <if @blog.title@ not nil>
    <h4><a name="blog-entry-@blog.entry_id@">@blog.title@</a></h4>
  </if>
    @blog.content@
    <if @admin_p@ eq 1>
      (<a href="@blog.edit_url@">Edit</a>) (<a href="@blog.delete_url@">Delete</a>)
      <if @draft_p@ eq "t">
	(<a href="@blog.publish_url@">Publish</a>)
      </if>
      <else>
	(<a href="@blog.revoke_url@">Revoke</a>)
      </else>
    </if>
    <br>
    <table cellpadding="0" cellspacing="0" border="0" width="100%">
      <if @show_poster_p@ true>
        <tr>
          <td>
            <font size="-2" color="#999999">
              <br>
              Posted by @blog.poster_first_names@ @blog.poster_last_name@ at @blog.posted_time_pretty@
            </font>
          </td>
        </tr>
      </if>
      <tr>
        <td align="right">
          <a href="@blog.entry_archive_url@" title="Permanent URL for this entry">#</a> -
          <a href="@blog.google_url@" title="Search for @blog.title@ on Google">G</a> -
          <if @blog.num_comments@ gt 0>
            <a href="@blog.comments_view_url@" title="View comments on this entry">@blog.num_comments@ comments</a> -
          </if>
          <a href="@blog.comment_add_url@" title="Comment on this entry">Add comment</a>    
        </td>
      </tr>
    </table>
  </div>
</multiple>

<a href="@archive_url@"><img src="@arrow_url@" width="11" height="11" border="0" alt="Archive"></a>
<a href="@archive_url@" class="action_link">Archive</a>
