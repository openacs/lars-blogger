<?xml version="1.0"?>

<queryset>
    <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

    <fullquery name="pinds_blog_entry__url.get_url_stub">
	<querytext>
         select site_node.url(node_id) as url_stub
         from   site_nodes s, pinds_blog_entries e
         where  e.entry_id = :object_id
         and    s.object_id = e.package_id		
	</querytext>
    </fullquery>

</queryset>
