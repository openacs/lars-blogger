<?xml version="1.0"?>

<queryset>

    <fullquery name="lars_blog__rss_datasource.select_package_id_user_id">
        <querytext>
			select package_id, user_id from weblogger_channels where channel_id = :summary_context_id
        </querytext>
    </fullquery>

    <fullquery name="lars_blog__rss_datasource.package_name">
        <querytext>
			select instance_name from apm_packages where package_id = :package_id
        </querytext>
    </fullquery>

    <fullquery name="lars_blog__rss_lastUpdated.select_package_id_user_id">
        <querytext>
			select package_id, user_id from weblogger_channels where channel_id = :summary_context_id
        </querytext>
    </fullquery>

</queryset>
