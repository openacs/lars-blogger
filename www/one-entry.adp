<master>
<property name="title">@page_title@</property>
<h2>@page_title@</h2>
<include src="admin-links">
@context_bar@
<hr>

<if @title@ not nil>
  <h4>@title@</h4>
</if>
<p>
  @content@
  <if @admin_p@ eq 1>
    (<a href="@edit_url@">Edit</a>) (<a href="@delete_url@">Delete</a>)
    <if @draft_p@ eq "t">
      (<a href="@publish_url@">Publish</a>)
    </if>
    <else>
      (<a href="@revoke_url@">Revoke</a>)
    </else>
  </if>
</p>

<if @comments_html@ not nil>
  <table align=center width="50%"><tr><td><hr></td></tr></table>
  <h4>Comments</h4>
  <blockquote>
   @comments_html@
  </blockquote>
</if>

<center><a href="@comment_add_url@">Add comment</a></center>
