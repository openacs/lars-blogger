<master> 
<property name="title">E-mail subscribers</property>
<property name="context">subscribers</property>

<ul>
<if @subscribers:rowcount@ gt 0>
<multiple name="subscribers">
<li>
        <a href="@subscribers.user_url@">@subscribers.name@</a>
        &lt;<a href="mailto:@subscribers.email@">@subscribers.email@</a>&gt;
</multiple>
</ul>
</if>
<else>
<em>No subscribers.</em>
</else>