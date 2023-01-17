require "fluent/plugin/parser"

module Fluent
  module Plugin
    class LibvirtParser < Fluent::Plugin::Parser
      Fluent::Plugin.register_parser("libvirt", self)

      config_set_default :time_key, "0"

      def parse(text)
      end
    end
  end
end
