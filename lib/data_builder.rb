require "data_builder/version"

require "data_reader"

module DataBuilder
  extend DataReader

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

    data.merge(specified).clone
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

  def builder_source
    ENV['DATA_BUILDER_SOURCE'] || 'default.yml'
  end
end
