<?xml version="1.0"?>

<queryset>
    <fullquery name="link_delete">
        <querytext>
	begin
	    weblogger_blogroll_entry.del(:link_id);
	end;
        </querytext>
    </fullquery>
</queryset>
