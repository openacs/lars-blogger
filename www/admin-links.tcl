set admin_p [ad_permission_p [ad_conn package_id] admin]

multirow create links url value title
multirow append links "[ad_conn package_url]admin/entry-edit" "Add entry" "Add an entry to this blog"
multirow append links "[ad_conn package_url]admin/" "Administer" "Visit the administration pages for this blog"

ad_return_template
