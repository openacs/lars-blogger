<master>
<property name="title">@page_title@</property>
<property name="context_bar">@context_bar@</property>

<table cellspacing=0 cellpadding=0 border=0>
  <tr>
    <td bgcolor="#cccccc">
      <table cellspacing=1 cellpadding=2 border=0 width="100%">
        <tr bgcolor="@header_background_color@">
          <th>Date</th>
          <th>Title</th>
          <th>Content</th>
          <th>Action</th>
        </tr>
        <multiple name="draft_entries">
          <tr bgcolor="#eeeeee">
            <td>@draft_entries.entry_date_pretty@</td>
            <td>@draft_entries.title@</td>
            <td>@draft_entries.content@</td>
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

<ul>
<li><a href="@entry_add_url@">Add another draft entry</a>
</ul>