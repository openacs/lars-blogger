<?xml version="1.0"?>
<!DOCTYPE queryset PUBLIC "-//OpenACS//DTD XQL 1.0//EN" "http://www.thecodemill.biz/repository/xql.dtd">
<!-- packages/lars-blogger/tcl/notification-procs-oracle.xql -->
<!-- @author Stan Kaufman (skaufman@epimetrics.com) -->
<!-- @creation-date 2005-03-01 -->
<!-- @cvs-id $Id$ -->

<queryset>
  
  <rdbms>
    <type>oracle</type>
    <version>8.1.6</version>
  </rdbms>
  
  <fullquery name="lars_blogger::notification::get_url.select_weblog_package_url">
    <querytext>
      select site_node.url(node_id) 
      from site_nodes
      where object_id = :entry_id
    </querytext>
  </fullquery>

</queryset>
