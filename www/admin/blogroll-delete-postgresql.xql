<?xml version="1.0"?>

<queryset>
    <rdbms><type>postgresql</type><version>7.2</version></rdbms>

    <fullquery name="link_delete">
        <querytext>
        select weblogger_blogroll_entry__delete(:link_id);
        </querytext>
    </fullquery>
</queryset>
