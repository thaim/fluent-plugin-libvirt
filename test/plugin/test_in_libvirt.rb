require "helper"
require "fluent/plugin/in_libvirt.rb"

class LibvirtInputTest < Test::Unit::TestCase
  setup do
    Fluent::Test.setup
  end

  test "failure" do
    flunk
  end

  private

  def create_driver(conf)
    Fluent::Test::Driver::Input.new(Fluent::Plugin::LibvirtInput).configure(conf)
  end
end
