<?xml version="1.0"?>

<queryset>
    <rdbms><type>postgresql</type><version>7.1</version></rdbms>

    <fullquery name="today">
        <querytext>
			select to_char(current_timestamp, 'YYYY-MM-DD') 
        </querytext>
    </fullquery>

    <partialquery name="now">
        <querytext>
			posted_date = current_timestamp
        </querytext>
    </partialquery>

</queryset>
