<?xml version="1.0"?>

<queryset>
    <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

    <fullquery name="create_subscr">
        <querytext>
            begin
                :1 := rss_gen_subscr.new (
                          null,
                          acs_sc_impl.get_id(
                              impl_contract_name => 'RssGenerationSubscriber',
                              impl_name => 'pinds_blog_entries'
                          ),
                          :package_id,
                          :timeout,                                 
                          null,
                          'rss_gen_subscr',                         
                          sysdate,                                    
                          :creation_user,                           
                          :creation_ip,                             
                          :package_id
                      );
            end;
        </querytext>
    </fullquery>

</queryset>
