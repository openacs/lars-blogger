<?xml version="1.0"?>

<queryset>
    <fullquery name="select_n_comments">
        <querytext>
    select * from (
        select
            r.title,
            r.publish_date,
            e.entry_id,
            person.name(o.creation_user) as item_author
        from
            cr_revisions r,
            cr_items i,
            general_comments c,
            pinds_blog_entries e,
            acs_objects o
        where
            e.package_id = :package_id and
            c.object_id = e.entry_id and
            i.item_id = c.comment_id and
            i.live_revision = r.revision_id and
            i.item_id = o.object_id
        order by
            r.publish_date desc
     ) where rownum <= $number_of_comments
                </querytext>
    </fullquery>
</queryset>
