<?xml version="1.0"?>

<queryset>

    <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

    <fullquery name="link_delete">
        <querytext>
	begin
	    weblogger_blogroll_entry.del(:link_id);
	end;
        </querytext>
    </fullquery>
</queryset>
