<?xml version="1.0"?>

<queryset>
    <rdbms><type>postgresql</type><version>7.2</version></rdbms>

    <fullquery name="lars_blogger::blogroll::delete_from_package.delete_from_package">
        <querytext>
            select  weblogger_blogroll_entry__delete(link_id)
            from    weblogger_blogroll_entries
            where   package_id = :package_id
        </querytext>
    </fullquery>
</queryset>