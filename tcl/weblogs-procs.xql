<?xml version="1.0"?>

<queryset>

    <fullquery name="lars_blogger::instance::remove_ping_url.remove_ping_url">
        <querytext>
            delete from weblogger_ping_urls
                where package_id = :package_id
                and ping_url = :ping_url
        </querytext>
    </fullquery>
    
    <fullquery name="lars_blogger::instance::add_ping_url.add_ping_url">
        <querytext>
            insert into weblogger_ping_urls (
                package_id,
                ping_url
            ) values (
                :package_id,
                :ping_url
            )
        </querytext>
    </fullquery>
    
    <fullquery name="lars_blogger::instance::get_ping_urls.get_ping_urls">
        <querytext>
            select ping_url
            from weblogger_ping_urls
            where package_id = :package_id
            order by ping_url asc
        </querytext>
    </fullquery>

</queryset>
