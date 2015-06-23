  <div class="lars_blogger_title">
    <ul>
      
      <multiple name="titles">
	<p>
	  <if @titles.title_url@ not nil>
	    <li>
	      <a href="@titles.title_url@"><b><if @titles.title@ not nil>@titles.title;noquote@</if><else>@titles.title_url@</else></b></a>
	      
	      <if @titles.title_url_base@ not nil>
		<span class="lars_blogger_title_url">[@titles.title_url_base@]</span>
	    </if>
	    <a href="@titles.permalink_url;noquote@>...more</a>
	    </li>
	    </if>
	      <else>
	      <if @titles.title@ not nil>
	      <li><a href="@titles.permalink_url@">@titles.title;noquote@</a></li>
	</if>
      </else>
      </p>
    </multiple>  
    </ul>
  <ul class="action-links">
    <if @blog_url@ not nil>
      <li><a href="@blog_url@" title="Visit @blog_name@ home">@blog_name@</a></li>
    </if>
  </ul>
  </div> 
  

  
