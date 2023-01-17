require "helper"
require "fluent/plugin/parser_libvirt.rb"

class LibvirtParserTest < Test::Unit::TestCase
  setup do
    Fluent::Test.setup
  end

  test "success" do
  end

  private

  def create_driver(conf)
    Fluent::Test::Driver::Parser.new(Fluent::Plugin::LibvirtParser).configure(conf)
  end
end
