<?xml version="1.0"?>

<queryset>

    <fullquery name="lars_blogger::category::get_existing_short_names.short_names">
        <querytext>
	        select short_name
                from pinds_blog_categories
                where package_id = :package_id
        </querytext>
    </fullquery>

    <fullquery name="lars_blogger::category::edit.update_category">
        <querytext>
            update pinds_blog_categories
            set    name = :name, 
                   short_name = :short_name
            where  category_id = :category_id
        </querytext>
    </fullquery>

    <fullquery name="lars_blogger::category::get_id_by_name.select_category_id">
        <querytext>
	select category_id
	from   pinds_blog_categories 
	where  package_id = :package_id 
	and    name = :category_name 
        </querytext>
    </fullquery>

</queryset>

