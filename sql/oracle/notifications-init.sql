
--
-- The Forums Package
--
-- @author gwong@orchardlabs.com,ben@openforce.biz
-- @creation-date 2002-05-16
--
-- This code is newly concocted by Ben, but with significant concepts and code
-- lifted from Gilbert's UBB forums. Thanks Orchard Labs.
--

-- the integration with Notifications

declare
        impl_id integer;
        v_foo   integer;
begin
        -- the notification type impl
        impl_id := acs_sc_impl.new (
                      'NotificationType',
                      'lars_blogger_notif_type',
                      'lars_blogger_notif_type',
                      'lars-blogger'
                   );

        v_foo := acs_sc_impl.new_alias (
                    'NotificationType',
                    'lars_blogger_notif_type',
                    'GetURL',
                    'lars_blogger::notification::get_url',
                    'TCL'
                 );

        v_foo := acs_sc_impl.new_alias (
                    'NotificationType',
                    'lars_blogger_notif_type',
                    'ProcessReply',
                    'lars_blogger::notification::process_reply',
                    'TCL'
                 );

        acs_sc_binding.new (
                    contract_name => 'NotificationType',
                    impl_name => 'lars_blogger_notif_type'
                 );

        v_foo:= notification_type.new (
                short_name => 'lars_blogger_notif',
                sc_impl_id => impl_id,
                pretty_name => 'Blog Notification',
                description => 'Notifications for Blog',
                creation_user => NULL,
                creation_ip => NULL
                );

        -- enable the various intervals and delivery methods
        insert into notification_types_intervals
        (type_id, interval_id)
        select v_foo, interval_id
        from notification_intervals where name in ('instant','hourly','daily');

        insert into notification_types_del_methods
        (type_id, delivery_method_id)
        select v_foo, delivery_method_id
        from notification_delivery_methods where short_name in ('email');


end;
/
show errors
