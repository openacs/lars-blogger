<master>
<property name="title">@page_title@</property>
<property name="context_bar">@context_bar@</property>   

<if @blog.title@ not nil>
  <h4>@blog.title@</h4>
</if>
<p>
  @blog.content@
  <br>
  <table cellpadding="0" cellspacing="0" border="0" width="100%">
    <if @show_poster_p@ true>
      <tr>
        <td>
          <font size="-2" color="#999999">
            <br>
            Posted by @blog.poster_first_names@ @blog.poster_last_name@ at @blog.posted_time_pretty@
            <if @admin_p@ eq 1>
              &nbsp;&nbsp;&nbsp;&nbsp;
              <a href="@blog.edit_url@">Edit</a> - <a href="@blog.delete_url@">Delete</a> -
              <if @blog.draft_p@ eq "t">
                <a href="@blog.publish_url@">Publish</a>
              </if>
              <else>
                <a href="@blog.revoke_url@">Revoke</a>
              </else>
            </if>
          </font>
        </td>
      </tr>
    </if>
    <tr>
      <td align="right">
        <a href="@blog.entry_archive_url@" title="Permanent URL for this entry">#</a> -
        <a href="@blog.google_url@" title="Search for @blog.title@ on Google">G</a> -
        <a href="@blog.comment_add_url@" title="Comment on this entry">Add comment</a>    
      </td>
    </tr>
  </table>
</p>

<if @comments_html@ not nil>
  <table align=center width="50%"><tr><td><hr></td></tr></table>
  <h4>Comments</h4>
  <blockquote>
   @comments_html@
  </blockquote>
</if>
