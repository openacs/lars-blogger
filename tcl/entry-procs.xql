<?xml version="1.0"?>

<queryset>

    <fullquery name="lars_blogger::entry::get.select_entry">
        <querytext>
                select creation_user 
                from   acs_objects 
                where  object_id = :entry_id

        </querytext>
    </fullquery>

</queryset>


