-- Add a table for ping URLs i.e. services that use the weblogs.com
-- ping interface.
create table weblogger_ping_urls (
  package_id        integer
                    constraint weblogger_ping_urls_package_id_fk
                    references apm_packages(package_id)
                    on delete cascade,
  ping_url          varchar2(500)
                    constraint weblogger_ping_urls_ping_url_nn
                    not null,
  creation_date     date default sysdate,
  constraint weblogger_ping_urls_pk
  primary key(package_id, ping_url)
);


-- Merge entry_date and posted_date column
update pinds_blog_entries
set    entry_date = to_date(to_char(entry_date, 'YYYY-MM-DD') || ' ' || to_char(posted_date, 'HH24:MI:SS'), 'YYYY-MM-DD HH24:MI:SS');

alter table pinds_blog_entries drop column posted_date;

-- Reload PL packages
@@ ../lars-blogger-package-create.sql
