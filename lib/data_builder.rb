require "data_builder/core_ext/hash"
require "data_builder/core_ext/integer"
require "data_builder/version"
require "data_builder/generation"
require "data_builder/generation_date"
require "data_builder/generation_standard"

require "data_reader"
require "faker"

module DataBuilder
  extend DataReader
  extend DateGeneration
  extend StandardGeneration

  attr_reader :parent

  def self.included(caller)
    @parent = caller
    generators.each do |generator|
      Generation.send :include, generator
    end
  end

  class << self
    attr_accessor :data_source

    def default_data_path
      'data'
    end

    def data_files_for(scenario)
      tags = scenario.send(scenario.respond_to?(:tags) ? :tags : :source_tags)
      tags.map(&:name).select { |t| t =~ /@databuilder_/ }.map do |t|
        t.gsub('@databuilder_', '').to_sym
      end
    end

    alias data_for_scenario data_files_for

    if I18n.respond_to? :enforce_available_locales
      I18n.enforce_available_locales = false
    end

    def locale=(value)
      Faker::Config.locale = value
    end

    def generators
      @generators || []
    end
  end

  def data_about(key, specified = {})
    if key.is_a?(String) && key.match(%r{/})
      file, record = key.split('/')
      DataBuilder.load("#{file}.yml")
    else
      record = key.to_s
      DataBuilder.load(builder_source) unless DataBuilder.data_source
    end

    data = DataBuilder.data_source[record]
    raise ArgumentError, "Undefined key for data: #{key}" unless data

    # rubocop:disable Metrics/LineLength
    process_data(data.merge(specified.key?(record) ? specified[record] : specified).deep_copy)
    # rubocop:enable Metrics/LineLength
  end

  alias data_from data_about
  alias data_for data_about
  alias using_data_for data_about
  alias using_data_from data_about

  def self.use_in_scenario(scenario, data_location = DataBuilder.data_path)
    original_data_path = DataBuilder.data_path
    DataBuilder.data_path = data_location
    data_files = data_files_for(scenario)
    DataBuilder.load("#{data_files.last}.yml") if data_files.count.positive?
    DataBuilder.data_path = original_data_path
  end

  private

  def process_data(data)
    case data
      when Hash
        data.each { |key, value| data[key] = process_data(value) }
      when Array
        data.each_with_index { |value, i| data[i] = process_data(value) }
      when String
        return generate(data[1..-1]) if data[0, 1] == "~"
    end
    data
  end

  def generate(value)
    generation.send :process, value
  rescue StandardError => e
    fail "Failed to generate: #{value}\n Reason: #{e.message}\n"
  end

  def generation
    @generation ||= Generation.new parent
  end

  def builder_source
    ENV['DATA_BUILDER_SOURCE'] || 'default.yml'
  end
end
