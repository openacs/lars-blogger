set package_id [ad_conn package_id]

db_multirow -extend {user_url} subscribers get_subscribers {
	select r.request_id, 
           u.first_names || ' ' || u.last_name as name, 
           u.user_id, 
           u.email,
	   (select name
	   from notification_intervals i
	   where i.interval_id = r.interval_id) as interval,
           r.object_id
	from notification_requests r, cc_users u
        where r.object_id = :package_id
          and u.user_id = r.user_id
} {
    set user_url [acs_community_member_url -user_id $user_id]
}
