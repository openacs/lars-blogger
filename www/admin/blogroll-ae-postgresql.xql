<?xml version="1.0"?>

<queryset>
    <rdbms><type>postgresql</type><version>7.2</version></rdbms>

    <fullquery name="link_select">
        <querytext>
        select
            name,
            url
        from
            weblogger_blogroll_entries
        where
            package_id = :package_id
        and link_id = :link_id
        </querytext>
    </fullquery>

    <fullquery name="link_add">
        <querytext>
        select weblogger_blogroll_entry__new (
            NULL,
            :package_id,
            :name,
            :url,
            :user_id,
            :ip
        )
        </querytext>
    </fullquery>
    
    <fullquery name="link_edit">
        <querytext>
        update weblogger_blogroll_entries
        set     name = :name,
                url = :url
        where
                link_id = :link_id
            and package_id = :package_id
        </querytext>
    </fullquery>
</queryset>
