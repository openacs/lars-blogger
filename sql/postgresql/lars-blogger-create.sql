--
-- lars-blogger-create.sql
-- 
-- @author Lars Pind
-- 
-- @cvs-id $Id$
--

\i lars-blogger-categories-create.sql

select acs_object_type__create_type (
    'pinds_blog_entry',             -- object_type
    'Blog Entry',                   -- pretty_name
    'Blog Entries',                 -- pretty_plural
    'acs_object',                   -- supertype
    'pinds_blog_entries',           -- table_name
    'entry_id',                     -- id_column
    null,                           -- package_name
    'f',                            -- abstract_p
    null,                           -- type_extension_table
    'pinds_blog_entry__title'       -- name_method
);

create table pinds_blog_entries (
  entry_id              integer
                        constraint pinds_blog_entry_id_fk
                        references acs_objects(object_id)
                        constraint pinds_blog_entries_pk
                        primary key,
  package_id            integer
                        constraint pinds_blog_entry_package_id_kf
                        references apm_packages(package_id),
  title                 varchar(500),
  title_url             varchar(500),
  category_id           integer
                        constraint pinds_blog_entry_category_fk 
                        references pinds_blog_categories(category_id),
  content               varchar(32000),
  content_format        varchar(50) 
                        default 'text/html'
                        constraint pinds_blog_entr_cnt_format_nn
                        not null,
  entry_date            timestamptz,
  posted_date           timestamptz,
  draft_p               char(1) default 'f'
                        constraint pinds_blog_entries_draft_ck
                        check (draft_p in ('t','f')),
  deleted_p             char(1) default 'f'
                        constraint pinds_blog_entries_deleted_ck
                        check (deleted_p in ('t','f'))
);

create index pinds_blog_entry_pck_entr_idx on pinds_blog_entries (package_id, entry_date);

select acs_object_type__create_type (
    'weblogger_channel',        -- object_type
    'Weblogger Channel',        -- pretty_name
    'Weblogger Channels',       -- pretty_plural
    'acs_object',               -- supertype
    'weblogger_channels',       -- table_name
    'channel_id',       	-- id_column
    null,               	-- package_name
    'f',        	        -- abstract_p
    null,   	                -- type_extension_table
    null                        -- name_method
);

create table weblogger_channels (
  channel_id    	integer
                        constraint channel_id_fk
                        references acs_objects(object_id)
                        constraint weblogger_channels_pk
                        primary key,
  package_id            integer
                        constraint weblogger_channels_package_id_kf
                        references apm_packages(package_id),
  user_id		integer,
  constraint weblogger_chnls_package_user_un
  unique (package_id, user_id)
);

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
    creation_date   timestamptz default now(),
    constraint weblogger_ping_urls_pk
        primary key(package_id, ping_url)
);

\i lars-blogger-pb.sql

\i rss-register.sql
\i notifications-init.sql
