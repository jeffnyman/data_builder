$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "data_builder"

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
