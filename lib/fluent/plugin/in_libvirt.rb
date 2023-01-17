require "fluent/plugin/input"

module Fluent
  module Plugin
    class LibvirtInput < Fluent::Plugin::Input
      Fluent::Plugin.register_input("libvirt", self)
    end
  end
end
