-- Add a table for ping URLs i.e. services that use the weblogs.com
-- ping interface.
create table weblogger_ping_urls (
    package_id      integer
                    constraint weblogger_ping_urls_package_id_fk
                        references apm_packages(package_id)
			on delete cascade,
    ping_url        varchar(500)
                    constraint weblogger_ping_urls_ping_url_nn
                        not null,
    creation_date   timestamptz
			default now(),
    constraint weblogger_ping_urls_pk
        primary key(package_id, ping_url)
);
