<?xml version="1.0"?>

<queryset>
    <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

    <fullquery name="today">
        <querytext>
			select to_char(sysdate, 'YYYY-MM-DD') from dual
        </querytext>
    </fullquery>

    <partialquery name="now">
        <querytext>
			posted_date = sysdate
        </querytext>
    </partialquery>

</queryset>
