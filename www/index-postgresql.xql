<?xml version="1.0"?>

<queryset>
    <rdbms><type>postgresql</type><version>7.1</version></rdbms>

    <fullquery name="bloggers">
        <querytext>
		    select distinct screen_name
		    from   pinds_blog_entries e join 
		           acs_objects o on (o.object_id = e.entry_id) join 
		           users u on (u.user_id = o.creation_user)
		    where  package_id = :package_id
                    and    screen_name != ''
        </querytext>
    </fullquery>

</queryset>
