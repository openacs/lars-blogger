set package_id [ad_conn package_id]

set admin_p [ad_permission_p $package_id admin]

set package_url [lars_package_url_from_package_id $package_id]

multirow create links url value title
multirow append links "${package_url}admin/entry-edit" "Add entry" "Add an entry to this blog"
multirow append links "${package_url}admin/" "Administer" "Visit the administration pages for this blog"

ad_return_template
