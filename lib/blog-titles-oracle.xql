<?xml version="1.0"?>
<!DOCTYPE queryset PUBLIC "-//OpenACS//DTD XQL 1.0//EN"
"http://www.thecodemill.biz/repository/xql.dtd">
<!-- packages/lars-blogger/lib/blog-titles-oracle.xql -->
<!-- @author sussdorff aolserver (sussdorff@ipxserver.de) -->
<!-- @creation-date 2005-02-21 -->
<!-- @arch-tag: a8fca7c3-86f7-4b6e-ad6b-649533d2a70d -->
<!-- @cvs-id $Id$ -->

<queryset>
  
  <rdbms>
    <type>oracle</type>
    <version>8.1.6</version>
  </rdbms>
  
  	<partialquery name="date_clause_default">
		<querytext>
			entry_date > sysdate - :num_days
		</querytext>
	</partialquery>

</queryset>