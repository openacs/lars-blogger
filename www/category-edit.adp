<master>
<property name="title">@page_title@</property>
<property name="focus">entry.title</property>   
<property name="context">@context@</property>   

<formtemplate id="category" style="standard-lars"></formtemplate>



<ul>
<multiple name="categories">
  <li>
  @categories.name@ &minus; @categories.short_name@
  (<a href="category-edit?category_id=@categories.category_id@">edit</a>
  |
  <a href="category-delete?category_id=@categories.category_id@&return_url=category-edit">delete</a>)
  </li>
</multiple>
</ul>
<if @insert_or_update@ eq update>
<a href="category-edit">Add new category</a>
</if>

