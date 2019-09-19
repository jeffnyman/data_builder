class TestPage
  include DataBuilder
end

class ScenarioMock
  attr_accessor :tags

  def initialize(tags)
    @tags = tags
  end
end

class TagMock
  attr_reader :name, :line

  def initialize(name, line)
    @name = name
    @line = line
  end
end

RSpec.describe DataBuilder do
  it "has a version number" do
    expect(DataBuilder::VERSION).not_to be nil
  end

  it "will accept and use a locale" do
    expect(Faker::Config).to receive(:locale=).with('test-us')
    DataBuilder.locale = 'test-us'
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
      expect(DataBuilder.data_path).to eq('data')
      DataBuilder.load("account.yml")
      data = TestPage.new.data_for "test"
      expect(data.keys.sort).to eq(['name','owner'])
    end

    it "defaults to reading a file named default.yml" do
      DataBuilder.data_path = 'data'
      DataBuilder.data_contents = nil
      data = TestPage.new.data_about :test
      expect(data.keys).to include "data_01"
    end

    it "recognizes data builder environment variable" do
      DataBuilder.data_path = 'data'
      DataBuilder.data_contents = nil
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
      data = TestPage.new.data_for 'account/test', {'valid' => {'name' => 'TStories'}}
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

  context "when using data in a scenario context" do
    it "loads the data for a scenario" do
      DataBuilder.data_path = 'data'
      scenario = ScenarioMock.new(
        [TagMock.new('@tag', 1),
         TagMock.new('@databuilder_account', 1)]
      )
      expect(DataBuilder).to receive(:load).with('account.yml')
      DataBuilder.use_in_scenario(scenario)
    end

    it "uses the last data listed for a scenario if multiple exist" do
      scenario = ScenarioMock.new(
        [TagMock.new('@data_default', 1),
         TagMock.new('@databuilder_account', 1)]
      )
      expect(DataBuilder).to receive(:load).with('account.yml')
      DataBuilder.use_in_scenario(scenario)
    end

    it "allows data loading from a different location" do
      DataBuilder.data_path = 'features'
      scenario = ScenarioMock.new(
        [TagMock.new('@tag', 1),
         TagMock.new('@databuilder_account', 1)]
      )
      expect(DataBuilder).to receive(:load).with('account.yml')
      DataBuilder.use_in_scenario(scenario, 'config/data')
      expect(DataBuilder.data_path).to eq('features')
    end
  end
end
