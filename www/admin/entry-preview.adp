<master>
<property name="title">@page_title@</property>
<property name="context_bar">@context_bar@</property>   

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

