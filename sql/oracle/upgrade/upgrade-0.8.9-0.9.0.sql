--
-- Upgrade script
-- 
-- @author Simon Carstensen (simon@collaboraid.biz)
-- @creation-date 2003-06-13
--

declare
begin
    acs_object_type.create_type(
        object_type => 'weblogger_channel',
        pretty_name => 'Weblogger Channel',
        pretty_plural => 'Weblogger Channels',
        supertype => 'acs_object',
        table_name => 'weblogger_channel',
        id_column => 'channel_id',
        package_name => null,
        abstract_p => 'f',
        type_extension_table => null,
        name_method => null
    );
end;
/
show errors

create table weblogger_channels (
  channel_id    	        constraint weblogger_channels_cid_fk
                                references acs_objects(object_id)
                                constraint weblogger_channels_cid_pk
                                primary key,
  package_id                    constraint weblogger_channels_pid_kf
                                references apm_packages(package_id),
  user_id		        integer		
);

create or replace package weblogger_channel
as

    function new (
        channel_id in weblogger_channels.channel_id%TYPE default null,
        package_id in weblogger_channels.package_id%TYPE,
        user_id in weblogger_channels.user_id%TYPE default null,
        creation_user in acs_objects.creation_user%TYPE default null,
        creation_ip in acs_objects.creation_ip%TYPE default null
    ) return weblogger_channels.channel_id%TYPE;

    procedure delete (
        channel_id in weblogger_channels.channel_id%TYPE
    );

end weblogger_channel;
/
show errors


create or replace package body weblogger_channel
as

    function new (
        channel_id in weblogger_channels.channel_id%TYPE default null,
        package_id in weblogger_channels.package_id%TYPE,
        user_id in weblogger_channels.user_id%TYPE default null,
        creation_user in acs_objects.creation_user%TYPE default null,
        creation_ip in acs_objects.creation_ip%TYPE default null
    ) return weblogger_channels.channel_id%TYPE
    is
        v_channel_id weblogger_channels.channel_id%TYPE;
    begin

        v_channel_id := acs_object.new(
            object_id => weblogger_channel.new.channel_id,
            object_type => 'weblogger_channel',
            creation_date => sysdate,
            creation_user => weblogger_channel.new.creation_user,
            creation_ip => weblogger_channel.new.creation_ip,
            context_id => weblogger_channel.new.package_id
        );

        insert into weblogger_channels (
           channel_id, 
           package_id,
           user_id      
        ) values (
           v_channel_id, 
           weblogger_channel.new.package_id,
           weblogger_channel.new.user_id
        );

        return v_channel_id;

    end new;

    procedure delete (
        channel_id in weblogger_channels.channel_id%TYPE
    )
    is
    begin

        delete
        from weblogger_channels
        where channel_id = weblogger_channel.delete.channel_id;

        acs_object.delete(weblogger_channel.delete.channel_id);

    end delete;

end weblogger_channel;
/
show errors

-- Remove the new parameter rss_file_name and update the old one
-- We do this since the APM does not know that the old parameter
-- has been replaced and we want to retain the values of the old parameter
declare
    v_parameter_id integer;
begin

  select parameter_id into v_parameter_id
  from apm_parameters
  where parameter_name = 'rss_file_name';

  apm.unregister_parameter(v_parameter_id);

end;
/
show errors

update apm_parameters
        set parameter_name = 'rss_file_name',
            description = 'What name should we advertise the RSS feed under, relative to the blog mount point. Leave blank if no RSS feed.',
            default_value = 'rss.xml'
        where parameter_name = 'rss_file_url';
