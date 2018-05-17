
<div class="lars_blogger_entry">

  <div class="lars_blogger_title">
   <p>
    <if @blog.title_url@ not nil>
      <a href="@blog.title_url@"><b><if @blog.title@ not nil>@blog.title;noquote@</if><else>@blog.title_url@</else></b></a>

      <if @blog.title_url_base@ not nil>
        <span class="lars_blogger_title_url">[@blog.title_url_base@]</span>
      </if>
    </if>
    <else>
      <if @blog.title@ not nil and @perma_p@ false>
        <b>@blog.title;noquote@</b>
      </if>
    </else>
   </p>
  </div> 

  <div class="lars_blogger_text">
     @blog.content;noquote@
  </div>

  <p class="lars_blogger_poster">
    @blog.posted_time_pretty@ 
    <if @show_poster_p;literal@ true>
      #lars-blogger.lt_by_blogposter_first_n#
    </if>
    <if 1 eq 0>
      #lars-blogger.lt_I_put_this_hack_in_be#
      <multiple name="sw_category_multirow" delimiter=", ">
        <if @sw_category_multirow.rownum@ eq 1 and
            @sw_category_multirow.sw_category_name@ not nil>
          #lars-blogger.in#
        </if>
        <a href="@sw_category_multirow.sw_category_url@">@sw_category_multirow.sw_category_name@</a>
      </multiple>
    </if>
    <if 1 eq 0>
      #lars-blogger.lt_I_put_this_hack_in_be#
    <if @display_categories@ and @blog.category_id@ gt 0>
      #lars-blogger.in#
      <a href="@category_url@" title="@blog.category_name@">@blog.category_name@</a>
    </if>
    |
      </if>

    <a href="@blog.permalink_url@" title="Permanent URL for this entry">#lars-blogger.Permalink#</a>
    <if @show_comments_p;literal@ false>
      | <a href="@blog.permalink_url@" title="View comments on this entry">#lars-blogger.lt_Comments_blognum_comm#</a>
    </if>
    <if @manageown_p@ false or @blog.user_id@ eq @user_id@>
      <if @blog.write_p;literal@ true>
        | <a href="@blog.edit_url@">Edit</a>
        <if @blog.draft_p;literal@ true>
          | <a href="@blog.publish_url@">#lars-blogger.Publish#</a>
        </if>
        <else>
           <if @unpublish_p;literal@ true>| <a href="@blog.revoke_url@">#lars-blogger.Draft#</a></if>
        </else>
        | <a href="@blog.delete_url@">Delete</a>
      </if>
    </if>
  </p>
</div>

<if @comments:rowcount@ not nil>
  <multiple name="comments">
    <a name="comment@comments.comment_id@"></a>
    <h3 class="lars_blogger_comment_title">@comments.title@</h3>
    <p class="lars_blogger_comment_text">@comments.content;noquote@</p> 
    <p><if @comments.trackback_p;literal@ false>#lars-blogger.by_commentsauthor#</if><else>#lars-blogger.Trackback_from# <a href="@comments.trackback_url@" title="@comments.trackback_name@">@comments.trackback_name@</a></else> #lars-blogger.lt_on_commentspretty_dat#<if @admin_p;literal@ true> | <a href="@general_comments_package_url@comment-edit?comment_id=@comments.comment_id@&amp;return_url=@comment_return_url@">Edit</a> | <a href="@general_comments_package_url@admin/delete?comment_id=@comments.comment_id@&amp;return_url=@comment_return_url@">Delete</a></if></p>
  </multiple>
  <center><a href="@blog.comment_add_url@" title="Comment on this entry">#lars-blogger.Add_comment#</a></center>
</if>

