--
-- lars-blogger-blogroll-create.sql
--
-- @author Guan Yang (guan@unicast.org)
--

-- Simple blogroll feature
begin
    acs_object_type.create_type (
      object_type => 'weblogger_blogroll_entry',
      pretty_name => 'Blogroll Entry',
      pretty_plural => 'Blogroll Entries',
      supertype => 'acs_object',
      table_name => 'weblogger_blogroll_entries',
      id_column => 'link_id',
      package_name => 'lars-blogger',
      abstract_p => 'f',
      type_extension_table => null,
      name_method => 'weblogger_blogroll_entry.name'
    );
end;
/
show errors

create table weblogger_blogroll_entries (
    link_id             integer
                        constraint weblogr_blogrl_entrs_id_fk
                            references acs_objects(object_id)
                        constraint weblogr_blogrl_entrs_id_pk
                            primary key,
    package_id          integer
                        constraint weblogr_blogrl_entrs_pkg_id_fk
                            references apm_packages(package_id),
    name                varchar(500)
                        constraint weblogr_blogrl_entrs_name_nn
                            not null,
    url                 varchar(1000)
                        constraint weblogr_blogrl_entrs_url_nn
                            not null,
    sort_order          integer default 0
);

create or replace package weblogger_blogroll_entry
as
    function name (
        link_id           in weblogger_blogroll_entries.link_id%TYPE
    ) return weblogger_blogroll_entries.link_id%TYPE;

    function new (
        link_id           in weblogger_blogroll_entries.link_id%TYPE default null,
        package_id        in weblogger_blogroll_entries.package_id%TYPE,
        name              in weblogger_blogroll_entries.name%TYPE,
        url               in weblogger_blogroll_entries.url%TYPE,
        creation_user     in acs_objects.creation_user%TYPE,
        creation_ip       in acs_objects.creation_ip%TYPE
    ) return weblogger_blogroll_entries.link_id%TYPE;

    procedure del (
        link_id           in weblogger_blogroll_entries.link_id%TYPE
    );

end weblogger_blogroll_entry;
/
show errors

create or replace package body weblogger_blogroll_entry
as
    function name (
        link_id           in weblogger_blogroll_entries.link_id%TYPE
    ) return weblogger_blogroll_entries.link_id%TYPE
    is
      v_name weblogger_blogroll_entries.name%TYPE;
    begin

      select name into v_name
      from weblogger_blogroll_entries
      where link_id = weblogger_blogroll_entry.name.link_id;
    
      return v_name;
    
      exception when no_data_found then
        return '';

    end;

    function new (
        link_id           in weblogger_blogroll_entries.link_id%TYPE default null,
        package_id        in weblogger_blogroll_entries.package_id%TYPE,
        name              in weblogger_blogroll_entries.name%TYPE,
        url               in weblogger_blogroll_entries.url%TYPE,
        creation_user     in acs_objects.creation_user%TYPE,
        creation_ip       in acs_objects.creation_ip%TYPE
    ) return weblogger_blogroll_entries.link_id%TYPE
    is
      v_link_id weblogger_blogroll_entries.link_id%TYPE;
    begin

      v_link_id := acs_object.new(
        object_id => weblogger_blogroll_entry.new.link_id,
        object_type => 'weblogger_blogroll_entry',
        creation_date => sysdate,
        creation_user => weblogger_blogroll_entry.new.creation_user,
        creation_ip => weblogger_blogroll_entry.new.creation_ip,
        context_id => weblogger_blogroll_entry.new.link_id
      );
    
      insert into weblogger_blogroll_entries (
        link_id,
        package_id,
        name,
        url
      ) values (
        v_link_id,
        weblogger_blogroll_entry.new.package_id,
        weblogger_blogroll_entry.new.name,
        weblogger_blogroll_entry.new.url
      );
    
      return v_link_id;

    end;

    procedure del (
        link_id           in weblogger_blogroll_entries.link_id%TYPE
    )
    is
    begin
      delete from weblogger_blogroll_entries
      where link_id = weblogger_blogroll_entry.del.link_id;

      acs_object.del (
        object_id => weblogger_blogroll_entry.del.link_id
      );

    end;

end weblogger_blogroll_entry;
/
show errors
