<?xml version="1.0"?>

<queryset>
    <rdbms><type>postgresql</type><version>7.1</version></rdbms>

   <fullquery name="lars_blog_setup_feed.create_instance_channel">
        <querytext>
		select weblogger_channel__new (
			null,
            		:package_id,
			NULL,
			:creation_user,
			:creation_ip
        	)
        </querytext>
    </fullquery>

   <fullquery name="lars_blog_setup_feed.create_user_channel">
        <querytext>
		select weblogger_channel__new (
			null,
            		:package_id,
			:creation_user,
			:creation_user,
			:creation_ip
        	)
        </querytext>
    </fullquery>

    <fullquery name="lars_blog_setup_feed.create_subscr">
        <querytext>
            select rss_gen_subscr__new (
                null,                                      -- subscr_id
                acs_sc_impl__get_id('RssGenerationSubscriber','pinds_blog_entries'),
                                                           -- impl_id
                :summary_context_id,                       -- summary_context_id
                :timeout,                                  -- timeout
                null,                                      -- lastbuild
                'rss_gen_subscr',                          -- object_type
                now(),                                     -- creation_date
                :creation_user,                            -- creation_user
                :creation_ip,                              -- creation_ip
                :package_id                                -- context_id
            )
        </querytext>
    </fullquery>

    <fullquery name="lars_blog_list_user_blogs.blog_list">
        <querytext>

    select p.package_id 
    from apm_packages p
    where p.package_key = 'lars-blogger'
    and acs_permission__permission_p(p.package_id, :user_id, 'create')
    
        </querytext>
    </fullquery>
    
</queryset>
