<?xml version="1.0"?>

<queryset>
    <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

    <fullquery name="lars_package_url_from_package_id_internal.site_url">
        <querytext>
            select site_node.url(node_id)
            from site_nodes
            where object_id = :package_id 
        </querytext>
    </fullquery>

    <fullquery name="lars_blog_entry_add.entry_add">
        <querytext>
			begin
				:1 := pinds_blog_entry.new (
            		entry_id => :entry_id,
            		package_id => :package_id,
            		title => :title,
            		content => :content,
            		entry_date => to_date(:entry_date, 'YYYY-MM-DD'),
            		draft_p => :draft_p,
            		creation_user => :creation_user,
            		creation_ip => :creation_ip
        		);
			end;
        </querytext>
    </fullquery>

</queryset>
