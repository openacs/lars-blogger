<if @comments:rowcount@ gt 0>
  <ol class="lars_blogger_n_comments">
    <multiple name="comments">
      <li class="lars_blogger_n_comments_n"><if @comments.item_author@ not nil><span class="lars_blogger_n_comments_author">@comments.item_author@: </span></if><a href="@comments.entry_url@#comment@comments.comment_id@">@comments.title@</a></li>
    </multiple>
  </ol>
</if>
