<?xml version="1.0"?>

<queryset>
    <fullquery name="lars_blogger::entry::get.select_category">
        <querytext>
		    select name as category_name, short_name as category_short_name
		    from   pinds_blog_categories
                    where  category_id = :category_id
        </querytext>
    </fullquery>
</queryset>
