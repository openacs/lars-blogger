<?xml version="1.0"?>

<queryset>

    <fullquery name="categories">
        <querytext>
	        select c.category_id,
                       c.name, 
                       c.short_name,
                       (select count(*) 
                        from   pinds_blog_entries e
                        where  e.category_id = c.category_id) as num_entries
                from   pinds_blog_categories c
                where  c.package_id = :package_id
                order  by upper(c.name), c.name 
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

</queryset>

