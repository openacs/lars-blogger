<?xml version="1.0"?>
<!DOCTYPE queryset PUBLIC "-//OpenACS//DTD XQL 1.0//EN"
"http://www.thecodemill.biz/repository/xql.dtd">
<!-- packages/lars-blogger/lib/blog-titles-postgresql.xql -->
<!-- @author sussdorff aolserver (sussdorff@ipxserver.de) -->
<!-- @creation-date 2005-02-21 -->
<!-- @arch-tag: 3828c328-694c-400c-8b79-2e686be4d5c7 -->
<!-- @cvs-id $Id$ -->

<queryset>
  
  <rdbms>
    <type>postgresql</type>
    <version>7.2</version>
  </rdbms>
  
  	<partialquery name="date_clause_default">
		<querytext>
			entry_date > current_timestamp - interval '$num_days days'
		</querytext>
 	</partialquery>

</queryset>