--
-- The Forums Package
--
-- @author gwong@orchardlabs.com,ben@openforce.biz
-- @creation-date 2002-05-16
--
-- This code is newly concocted by Ben, but with significant concepts and code
-- lifted from Gilbert's UBB forums. Thanks Orchard Labs.
--

declare
begin
    for row in (select type_id
                from notification_types
                where short_name in ('lars_blogger_notif_type','lars_blogger_notif'))
    loop
        notification_type.del(row.type_id);
    end loop;
end;
/
show errors
