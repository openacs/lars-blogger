--
-- lars-blogger-create.sql
-- 
-- @author Lars Pind
-- @author Yon (Yon@milliped.com) Oracle Port
-- 
-- @cvs-id $Id$
--

declare
begin
    acs_object_type.create_type(
        object_type => 'pinds_blog_entry',
        pretty_name => 'Blog Entry',
        pretty_plural => 'Blog Entries',
        supertype => 'acs_object',
        table_name => 'pinds_blog_entries',
        id_column => 'entry_id',
        package_name => null,
        abstract_p => 'f',
        type_extension_table => null,
        name_method => 'pinds_blog_entry.title'
    );
end;
/
show errors

create table pinds_blog_entries (
    entry_id                    constraint pinds_blog_entry_id_fk
                                references acs_objects(object_id)
                                constraint pinds_blog_entries_pk
                                primary key,
    package_id                  constraint pinds_blog_entry_package_id_fk
                                references apm_packages(package_id),
    title                       varchar(500),
    content                     clob,
    content_format              varchar(50) 
                                default 'text/html'
                                constraint pinds_blog_entr_cnt_format_nn
                                not null,
    entry_date                  date,
    posted_date                 date,
    draft_p                     char(1) default 'f'
                                constraint pinds_blog_entries_draft_ck
                                check (draft_p in ('t','f')),
    deleted_p                   char(1) default 'f'
                                constraint pinds_blog_entries_deleted_ck
                                check (deleted_p in ('t','f'))
);


@@ lars-blogger-package-create
@@ rss-register
@@ notifications-init
