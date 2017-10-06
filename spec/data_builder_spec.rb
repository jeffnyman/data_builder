require "spec_helper"

class TestPage
  include DataBuilder
end

RSpec.describe DataBuilder do
  it "has a version number" do
    expect(DataBuilder::VERSION).not_to be nil
  end

  context "when configuring the data path" do
    before(:each) do
      DataBuilder.data_path = nil
    end

    it "defaults to a directory named data" do
      expect(DataBuilder.data_path).to eq('data')
    end

    it "stores a data source directory" do
      DataBuilder.data_path = 'config/data'
      expect(DataBuilder.data_path).to eq('config/data')
    end
  end

  context "when reading data files" do
    it "defaults to reading from a data directory" do
      DataBuilder.data_path = nil
      DataBuilder.load("account.yml")
      data = TestPage.new.data_for "test"
      expect(data.keys.sort).to eq(['name','owner'])
    end

    it "defaults to reading a file named default.yml" do
      DataBuilder.data_path = 'data'
      DataBuilder.data_source = nil
      data = TestPage.new.data_about :test
      expect(data.keys).to include "data_01"
    end

    it "recognizes data builder environment variable" do
      DataBuilder.data_path = 'data'
      DataBuilder.data_source = nil
      ENV['DATA_BUILDER_SOURCE'] = 'account.yml'
      data = TestPage.new.data_about "test"
      expect(data.keys.sort).to eq(['name','owner'])
      ENV['DATA_BUILDER_SOURCE'] = nil
    end

    it "merges specified data to a key" do
      DataBuilder.data_path = 'data'
      data = TestPage.new.data_for 'account/test', {'name' => 'TStories'}
      expect(data['name']).to eq('TStories')
    end

    it "merges specified data to a hash" do
      DataBuilder.data_path = 'data'
      data = TestPage.new.data_for 'account/test', { 'valid' => {'name' => 'TStories'} }
      expect(data['name']).to eq('TesterStories')
      expect(data['valid']).to eq({"name"=>"TStories"})
    end

    context 'namespaces' do
      it "retrieves data from the correct data file" do
        DataBuilder.data_path = 'data'
        data = TestPage.new.data_about "account/test"
        expect(data.keys.sort).to eq(['name','owner'])
      end
    end
  end
end
