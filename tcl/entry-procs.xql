<?xml version="1.0"?>

<queryset>

    <fullquery name="lars_blogger::entry::edit.update_entry">
        <querytext>
            update pinds_blog_entries
            set    [join $set_clauses ", "]
            where  entry_id = :entry_id
        </querytext>
    </fullquery>

</queryset>
