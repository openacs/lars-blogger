<?xml version="1.0"?>

<queryset>

    <fullquery name="categories">
        <querytext>
	        select * 
                from pinds_blog_categories
                where package_id = :package_id
        </querytext>
    </fullquery>

    <fullquery name="short_names">
        <querytext>
	        select short_name
                from pinds_blog_categories
                where package_id = :package_id
        </querytext>
    </fullquery>

    <fullquery name="category_exists">
        <querytext>
            select count(*) as category_exists
            from   pinds_blog_categories 
            where  category_id = :category_id
        </querytext>
    </fullquery>

    <fullquery name="short_name_exists">
        <querytext>
            select count(*) as short_name_exists
            from   pinds_blog_categories 
            where  short_name = :short_name and category_id <> :category_id and package_id = :package_id
        </querytext>
    </fullquery>

    <fullquery name="category">
        <querytext>
            select name, short_name
            from   pinds_blog_categories
            where  category_id = :category_id
        </querytext>
    </fullquery>

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

    <fullquery name="update_category">
        <querytext>
            update pinds_blog_categories
            set    name=:name, short_name=:short_name
            where  category_id = :category_id
        </querytext>
    </fullquery>

</queryset>

