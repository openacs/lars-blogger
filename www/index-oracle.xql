<?xml version="1.0"?>

<queryset>
    <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

    <fullquery name="bloggers">
        <querytext>
		    select distinct screen_name
		    from   pinds_blog_entries e,
		           acs_objects o,
		           users u
		    where  package_id = :package_id
                    and    o.object_id = e.entry_id
                    and    u.user_id = o.creation_user
        </querytext>
    </fullquery>

</queryset>
