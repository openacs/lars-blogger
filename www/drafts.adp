<master>
<property name="title">@page_title@</property>
<property name="context">@context@</property>

<if @draft_entries:rowcount@ eq 0>
  <i>No draft entries.</i>
</if>
<else>
  <table cellspacing=0 cellpadding=0 border=0>
    <tr>
      <td bgcolor="#cccccc">
        <table cellspacing=1 cellpadding=2 border=0 width="100%">
          <tr bgcolor="@header_background_color@">
            <th>Date</th>
            <th>Content</th>
            <th>Action</th>
          </tr>
          <multiple name="draft_entries">
            <tr bgcolor="#eeeeee">
              <td>@draft_entries.entry_date_pretty@</td>
              <td>
                <b>@draft_entries.title@</b>
                @draft_entries.content@
              </td>
              <td align="center">
                <a href="@draft_entries.preview_url@">Preview</a>
                <a href="@draft_entries.publish_url@">Publish</a>
                <a href="@draft_entries.edit_url@">Edit</a>
                <a href="@draft_entries.delete_url@">Delete</a>
              </td>
            </tr>
          </multiple>
        </table>
      </td>
    </tr>
  </table>
</else>

<p>
  <a href="@entry_add_url@"><img src="@arrow_url@" width="11" height="11" border="0" alt="Add entry"></a>
  <a href="@entry_add_url@" class="action_link">Add entry</a>
</p>
