<?xml version="1.0"?>

<queryset>
    <rdbms><type>postgresql</type><version>7.1</version></rdbms>

    <fullquery name="insert_category">
        <querytext>
	        select pinds_blog_category__new (
            		:category_id,
  	          	:package_id,
        	    	:name,
                	:short_name,
        	    	:creation_user,
            		:creation_ip
        	)
        </querytext>
    </fullquery>


</queryset>
