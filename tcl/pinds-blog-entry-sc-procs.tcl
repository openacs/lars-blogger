ad_library {
    Lars blogger search procs.

    @author Bart Teeuwisse (bart.teeuwisse@thecodemill.biz)
    @creation-date 2002-11-18
    @cvs $Id$
}

ad_proc pinds_blog_entry__datasource {
    object_id
} {
    @author Bart Teeuwisse (bart.teeuwisse@thecodemill.biz)
    @creation-date 2002-11-18
} {
    db_0or1row pinds_blog_entry_datasource {
        select e.entry_id as object_id,
               e.title as title,
               e.content as content,
               'text/html' as mime,
               '' as keywords,
               'text' as storage_type
        from pinds_blog_entries e
        where e.entry_id = :object_id
    } -column_array datasource

    return [array get datasource]
}


ad_proc pinds_blog_entry__url {
    object_id
} {
    @author Bart Teeuwisse (bart.teeuwisse@thecodemill.biz)
    @creation-date 2002-11-18
} {

    db_1row get_url_stub "
        select site_node__url(node_id) as url_stub
        from site_nodes s, pinds_blog_entries e
        where e.entry_id = :object_id
		and s.object_id = e.package_id"

    set url "${url_stub}one-entry?entry_id=$object_id"

    return $url
}


