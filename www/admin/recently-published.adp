<master>
<property name="title">@page_title@</property>
<property name="context_bar">@context_bar@</property>

<table cellspacing=0 cellpadding=0 border=0>
  <tr>
    <td bgcolor="#cccccc">
      <table cellspacing=1 cellpadding=2 border=0 width="100%">
        <tr bgcolor="#e0d0b0">
          <th>Date</th>
          <th>Title</th>
          <th>Content</th>
          <th>Action</th>
        </tr>
        <multiple name="entries">
          <tr bgcolor="#eeeeee">
            <td>@entries.entry_date_pretty@</td>
            <td>@entries.title@</td>
            <td>@entries.content@</td>
            <td align="center"><a href="@entries.edit_url@">Edit</a></td>
          </tr>
        </multiple>
      </table>
    </td>
  </tr>
</table>
