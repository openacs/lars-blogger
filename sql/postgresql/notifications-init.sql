--
-- The Weblogger Package
--
-- @author lars@pinds.com
-- @creation-date 2002-09-14
--

-- the integration with Notifications

create function inline_0() returns integer as '
declare
        impl_id integer;
        v_foo   integer;
begin
        -- the notification type impl
        impl_id := acs_sc_impl__new (
                      ''NotificationType'',
                      ''lars_blogger_notif_type'',
                      ''lars-blogger''
        );

        v_foo := acs_sc_impl_alias__new (
                    ''NotificationType'',
                    ''lars_blogger_notif_type'',
                    ''GetURL'',
                    ''lars_blogger::notification::get_url'',
                    ''TCL''
        );

        v_foo := acs_sc_impl_alias__new (
                    ''NotificationType'',
                    ''lars_blogger_notif_type'',
                    ''ProcessReply'',
                    ''lars_blogger::notification::process_reply'',
                    ''TCL''
        );

        PERFORM acs_sc_binding__new (
                    ''NotificationType'',
                    ''lars_blogger_notif_type''
        );

        v_foo:= notification_type__new (
	        NULL,
                impl_id,
                ''lars_blogger_notif'',
                ''Blog Notification'',
                ''Notifications for Blog'',
		now(),
                NULL,
                NULL,
		NULL
        );

        -- enable the various intervals and delivery methods
        insert into notification_types_intervals
        (type_id, interval_id)
        select v_foo, interval_id
        from notification_intervals where name in (''instant'',''hourly'',''daily'');

        insert into notification_types_del_methods
        (type_id, delivery_method_id)
        select v_foo, delivery_method_id
        from notification_delivery_methods where short_name in (''email'');

	return (0);
end;
' language 'plpgsql';

select inline_0();
drop function inline_0();
