<?xml version="1.0"?>

<queryset>
    <rdbms><type>postgresql</type><version>7.1</version></rdbms>

    <fullquery name="lars_blog_entry_add.entry_add">
        <querytext>
	        select pinds_blog_entry__new (
            		:entry_id,
  	          	:package_id,
        	    	:title,
                	:title_url,
	            	:content,
        	    	:content_format,
            		to_date(:entry_date, 'YYYY-MM-DD'),
	            	:draft_p,
        	    	:creation_user,
            		:creation_ip
        	)
        </querytext>
    </fullquery>

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

</queryset>
