<if @months:rowcount@ gt 0>
  <multiple name="months">
    <a href="@months.url@" title="View archive for @months.date_pretty@">@months.date_pretty@</a><br>
  </multiple>
</if>