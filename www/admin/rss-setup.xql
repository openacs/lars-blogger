<?xml version="1.0"?>

<queryset>

    <fullquery name="update_subscr">
        <querytext>
            update rss_gen_subscrs
            set    channel_title = :channel_title,
                   channel_link = :channel_link
            where  subscr_id = :subscr_id
        </querytext>
    </fullquery>

</queryset>
