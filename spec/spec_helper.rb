require "coveralls"
Coveralls.wear!

require "bundler/setup"
require "data_builder"

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new([
  Coveralls::SimpleCov::Formatter,
  SimpleCov::Formatter::HTMLFormatter,
])

SimpleCov.start do
  add_filter "spec/"
  coverage_dir "spec/coverage"
  minimum_coverage 90
  maximum_coverage_drop 5
end

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = "spec/.rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

RSpec::Matchers.define :have_field_value do |expected|
  supports_block_expectations

  match do |actual|
    actual["field"] === expected
  end

  failure_message do |actual|
    "expected '#{expected}' to equal the field value '#{actual['field']}'"
  end

  failure_message_when_negated do |actual|
    "expected '#{expected}' to not equal to field value '#{actual['field']}'"
  end
end
