require "fluent/plugin/parser"

module Fluent
  module Plugin
    class LibvirtParser < Fluent::Plugin::Parser
      Fluent::Plugin.register_parser("libvirt", self)

      config_set_default :time_format, '%Y-%m-%d %H:%M:%S.%L%z'.freeze
      config_set_default :time_key, "time"

      def parse(text)
        text.split("\n").each do |line|
          # time = "2023-01-16 13:00:00.500+0000"
          # record = {
          #   'msg' => 'starting up',
          #   'versions' => {
          #     'libvert version' => '8.0.0',
          #     'package' => '1ubuntu7.1 (Christian Ehrhardt <christian.ehrhardt@canonical.com> Thu, 19 May 2022 08:14:48 +0200)',
          #     'qemu version' => '6.2.0Debian 1:6.2+dfsg-2ubuntu6.3',
          #     'kernel' => '5.15.0-41-generic',
          #     'hostname' => 'devserver'
          #   },
          #   'env' => {'LC_ALL': 'C'},
          #   'command' => '/usr/bin/qemu-system-x86_64 -name guest=testvm,debug-threads=on -S -msg timestamp=on'
          # }

          values = line.split("\\")
          raw_record = {}
          status = "start"
          values.each_with_index do |value, index|
            if status == "start"
              if value.include?(": starting up ")
                raw_record['time'] = value.split(": starting up ")[0]
                raw_record['msg'] = "starting up"
                raw_record['versions'] = {}
                versions = value.split(": starting up ")[1]
              end
              versions.split(',').each do |version|
                k,v = version.split(':',2)
                raw_record['versions'][k.strip] = v.strip
              end


              status = "env"
            elsif status == "env" and value =~ /[a-zA-Z_]*=[a-zA-Z0-9]*/
              k, v = value.split('=', 2)
              if raw_record['env'] == nil
                raw_record['env'] = {}
              end
              raw_record['env'][k] = v.strip
            elsif status == "env" or status == "command"
              if raw_record['command'] == nil
                raw_record['command'] = value
              else
                raw_record['command'].concat(value)
              end
              status = "command"
            end
          end
          time, record = convert_values(parse_time(raw_record), raw_record)

          yield time, record
        end
      end
    end
  end
end
