<?xml version="1.0"?>

<queryset>
    <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

    <fullquery name="insert_category">
        <querytext>
	    begin   
                :1 := pinds_blog_category.new (
            		category_id => :category_id,
  	          	package_id => :package_id,
        	    	name => :name,
                	short_name => :short_name,
        	    	creation_user => :creation_user,
            		creation_ip => :creation_ip
        	);
            end;
        </querytext>
    </fullquery>


</queryset>
