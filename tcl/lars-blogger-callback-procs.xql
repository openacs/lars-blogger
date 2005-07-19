<?xml version="1.0"?>

<queryset>

    <fullquery name="callback::MergePackageUser::impl::lars_blogger.upd_channels">
        <querytext>	
        update weblogger_channels
	set user_id = :to_user_id
	where user_id = :from_user_id
        </querytext>
    </fullquery>	

    <fullquery name="callback::MergeShowUserInfo::impl::lars_blogger.sel_channels">
        <querytext>	
        select channel_id, package_id
        from weblogger_channels
        where user_id = :user_id
        </querytext>
    </fullquery>	

</queryset>
