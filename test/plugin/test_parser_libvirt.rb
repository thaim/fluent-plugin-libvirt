require "helper"
require "test-unit"
require "fluent/test/driver/parser"
require "fluent/plugin/parser_libvirt.rb"

class LibvirtParserTest < Test::Unit::TestCase
  setup do
    Fluent::Test.setup
  end

  CONFIG = {
  }

  test "simple starting up event" do
    d = create_driver('')
    log = "2023-01-17 13:00:00.500+0000: starting up libvirt version: 8.0.0, kernel: 5.15.0-41-generic\\LC_ALL=C \\/usr/bin/qemu-system-x86_64 \\-name guest=testvm,debug-threads=on \\-S \\-msg timestamp=on"

    t = event_time('2023-01-17 13:00:00.500+0000')
    r = {
      'msg' => 'starting up',
      'versions' => {
        'libvirt version' => '8.0.0',
        'kernel' => '5.15.0-41-generic',
      },
      'env' => {'LC_ALL' => 'C'},
      'command' => '/usr/bin/qemu-system-x86_64 -name guest=testvm,debug-threads=on -S -msg timestamp=on'
    }
    d.instance.parse(log) do |time, record|
      assert_equal t, time
      assert_equal r, record
    end
  end

  test "full starting up event" do
    log = "2023-01-17 13:00:00.500+0000: starting up libvirt version: 8.0.0, package: 1ubuntu7.1 (Christian Ehrhardt <christian.ehrhardt@canonical.com> Thu, 19 May 2022 08:14:48 +0200), qemu version: 6.2.0Debian 1:6.2+dfsg-2ubuntu6.3, kernel: 5.15.0-41-generic, hostname: devserver|LC_ALL=C |/usr/bin/qemu-system-x86_64 |-name guest=wnode04,debug-threads=on |-S |-msg timestamp=on"
    r = {
      'msg' => 'starting up',
      'versions' => {
        'libvirt version' => '8.0.0',
        'package' => '1ubuntu7.1 (Christian Ehrhardt <christian.ehrhardt@canonical.com> Thu, 19 May 2022 08:14:48 +0200)',
        'qemu version' => '6.2.0Debian 1:6.2+dfsg-2ubuntu6.3',
        'kernel' => '5.15.0-41-generic',
        'hostname' => 'devserver'
      },
    }
  end

  private

  def create_driver(conf)
    Fluent::Test::Driver::Parser.new(Fluent::Plugin::LibvirtParser).configure(conf)
  end
end
