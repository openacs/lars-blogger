<?xml version="1.0"?>

<queryset>

    <fullquery name="metaWeblog.getPost.package_id">
        <querytext>
            select package_id from pinds_blog_entries 
            where entry_id = :entry_id
        </querytext>
    </fullquery>

</queryset>
