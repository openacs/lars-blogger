<?xml version="1.0"?>

<queryset>

    <fullquery name="entry">
        <querytext>
		    select b.entry_id,  
                           b.title, 
                           b.content, 
                           b.draft_p, 
                           to_char(b.entry_date, 'YYYY-MM-DD') as entry_date,
        		   p.first_names as poster_first_names,
		           p.last_name as poster_last_name,
		           to_char(b.posted_date , 'HH24:MI') as posted_time_pretty
		    from   pinds_blog_entries b,
                           acs_objects o,
                           persons p
		    where  b.entry_id = :entry_id
                    and    o.object_id = b.entry_id
                    and    p.person_id = o.creation_user
        </querytext>
    </fullquery>

</queryset>
