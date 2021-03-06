require 'mocha/options'

require 'mocha/integration/mini_test/nothing'
require 'mocha/integration/mini_test/version_13'
require 'mocha/integration/mini_test/version_140'
require 'mocha/integration/mini_test/version_141'
require 'mocha/integration/mini_test/version_142_to_172'
require 'mocha/integration/mini_test/version_200'
require 'mocha/integration/mini_test/version_201_to_222'
require 'mocha/integration/mini_test/version_230_to_2101'
require 'mocha/integration/mini_test/version_2110_to_2111'
require 'mocha/integration/mini_test/version_2112_to_320'
require 'mocha/integration/mini_test/adapter'

mini_test_version = begin
  Gem::Version.new(MiniTest::Unit::VERSION)
rescue LoadError
  Gem::Version.new('0.0.0')
end

debug_puts "Detected MiniTest version: #{mini_test_version}"

minitest_integration_module = [
  Mocha::Integration::MiniTest::Adapter,
  Mocha::Integration::MiniTest::Version2112To320,
  Mocha::Integration::MiniTest::Version2110To2111,
  Mocha::Integration::MiniTest::Version230To2101,
  Mocha::Integration::MiniTest::Version201To222,
  Mocha::Integration::MiniTest::Version200,
  Mocha::Integration::MiniTest::Version142To172,
  Mocha::Integration::MiniTest::Version141,
  Mocha::Integration::MiniTest::Version140,
  Mocha::Integration::MiniTest::Version13,
  Mocha::Integration::MiniTest::Nothing
].detect { |m| m.applicable_to?(mini_test_version) }

unless MiniTest::Unit::TestCase < minitest_integration_module
  debug_puts "Applying #{minitest_integration_module.description}"
  MiniTest::Unit::TestCase.send(:include, minitest_integration_module)
end
