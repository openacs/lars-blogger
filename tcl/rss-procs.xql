<?xml version="1.0"?>

<queryset>

    <fullquery name="lars_blog__rss_datasource.package_name">
        <querytext>
			select instance_name from apm_packages where package_id = :package_id
        </querytext>
    </fullquery>

</queryset>
