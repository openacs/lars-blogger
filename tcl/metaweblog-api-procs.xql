<?xml version="1.0"?>

<queryset>

    <fullquery name="metaWeblog.getPost.package_id">
        <querytext>
            select package_id from pinds_blog_entries 
            where entry_id = :entry_id
        </querytext>
    </fullquery>

    <fullquery name="metaWeblog.getCategories.select_categories">
        <querytext>
            select name, short_name
            from   pinds_blog_categories
	    where  package_id = :package_id
	    order  by lower(name)
        </querytext>
    </fullquery>

</queryset>
