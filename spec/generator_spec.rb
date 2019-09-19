require "spec_helper"

RSpec.describe "DataBuilder Generators" do
  context "when delivering data" do
    let(:example) { (Class.new { include DataBuilder }).new }

    def set_field_value(value)
      expect(DataBuilder).to receive(:data_contents).twice.and_return({'key' => {'field' => value}})
    end

    it "will deep copy the data returned so that it can be reused" do
      yaml = double("yaml")
      expect(yaml).to receive(:merge).and_return(yaml)
      expect(DataBuilder).to receive(:data_contents).twice.and_return(yaml)
      expect(yaml).to receive(:[]).and_return(yaml)
      expect(yaml).to receive(:deep_copy).and_return({'field' => 'value'})
      expect(example.data_for('key')).to have_field_value "value"
    end

    it "will merge provided data with the data source data" do
      yaml = double("yaml")
      expect(DataBuilder).to receive(:data_contents).twice.and_return(yaml)
      expect(yaml).to receive(:[]).and_return(yaml)
      expect(yaml).to receive(:merge).and_return(yaml)
      expect(yaml).to receive(:deep_copy).and_return({'field' => 'value'})
      expect(example.data_for('key')).to have_field_value "value"
    end

    it "will deliver a hash from the data file" do
      set_field_value "value"
      expect(example.data_for("key")).to have_field_value "value"
    end

    it "will allow the use of symbols for the key" do
      set_field_value "value"
      expect(example.data_for(:key)).to have_field_value "value"
    end

    context "generating random names" do
      it "will generate a name" do
        expect(Faker::Name).to receive(:name).and_return("Jeff Nyman")
        set_field_value "~full_name"
        expect(example.data_for('key')).to have_field_value "Jeff Nyman"
      end

      it "will generate a first name" do
        expect(Faker::Name).to receive(:first_name).and_return("Jeff")
        set_field_value "~first_name"
        expect(example.data_for('key')).to have_field_value "Jeff"
      end

      it "will generate a last name" do
        expect(Faker::Name).to receive(:last_name).and_return("Nyman")
        set_field_value "~last_name"
        expect(example.data_for('key')).to have_field_value "Nyman"
      end

      it "will generate a name prefix" do
        expect(Faker::Name).to receive(:prefix).and_return("Mr")
        set_field_value "~name_prefix"
        expect(example.data_for('key')).to have_field_value "Mr"
      end

      it "will generate a name suffix" do
        expect(Faker::Name).to receive(:suffix).and_return("Jr")
        set_field_value "~name_suffix"
        expect(example.data_for('key')).to have_field_value "Jr"
      end

      it "will generate a title" do
        expect(Faker::Name).to receive(:title).and_return("Tester Person")
        set_field_value "~title"
        expect(example.data_for('key')).to have_field_value "Tester Person"
      end
    end

    context "generating address values" do
      it "will generate a street address" do
        expect(Faker::Address).to receive(:street_address).and_return("123 Test Lane")
        set_field_value "~street_address"
        expect(example.data_for('key')).to have_field_value "123 Test Lane"
      end

      it "will generate a secondary address" do
        expect(Faker::Address).to receive(:secondary_address).and_return("Suite 1200")
        set_field_value "~secondary_address"
        expect(example.data_for('key')).to have_field_value "Suite 1200"
      end

      it "will generate a city" do
        expect(Faker::Address).to receive(:city).and_return("Chicago")
        set_field_value "~city"
        expect(example.data_for('key')).to have_field_value "Chicago"
      end

      it "will generate a state" do
        expect(Faker::Address).to receive(:state).and_return("Illinois")
        set_field_value "~state"
        expect(example.data_for('key')).to have_field_value "Illinois"
      end

      it "will generate a state abbreviation" do
        expect(Faker::Address).to receive(:state_abbr).and_return("IL")
        set_field_value "~state_abbr"
        expect(example.data_for('key')).to have_field_value "IL"
      end

      it "will generate a zip code" do
        expect(Faker::Address).to receive(:zip).and_return("60606")
        set_field_value "~zip_code"
        expect(example.data_for('key')).to have_field_value "60606"
      end

      it "will generate a country" do
        expect(Faker::Address).to receive(:country).and_return("United States")
        set_field_value "~country"
        expect(example.data_for('key')).to have_field_value "United States"
      end
    end

    context "generating credit cards" do
      it "will generate a credit card number" do
        expect(Faker::Business).to receive(:credit_card_number).and_return("12345678")
        set_field_value "~credit_card_number"
        expect(example.data_for('key')).to have_field_value "12345678"
      end

      it "will generate a credit card type" do
        expect(Faker::Business).to receive(:credit_card_type).and_return("visa")
        set_field_value "~credit_card_type"
        expect(example.data_for('key')).to have_field_value "visa"
      end
    end

    context "generating phone numbers" do
      it "should generate a phone number" do
        expect(Faker::PhoneNumber).to receive(:phone_number).and_return("555-555-5555")
        set_field_value "~phone_number"
        expect(example.data_for('key')).to have_field_value "555-555-5555"
      end

      it "should generate a cell phone number" do
        expect(Faker::PhoneNumber).to receive(:cell_phone).and_return("555-555-5555")
        set_field_value "~cell_phone"
        expect(example.data_for('key')).to have_field_value "555-555-5555"
      end
    end

    context "company generators" do
      it "will generate a company name" do
        expect(Faker::Company).to receive(:name).and_return("TesterCo")
        set_field_value "~company_name"
        expect(example.data_for('key')).to have_field_value "TesterCo"
      end

      it "will generate a catch phrase" do
        expect(Faker::Company).to receive(:catch_phrase).and_return("Test or Die!")
        set_field_value "~catch_phrase"
        expect(example.data_for('key')).to have_field_value "Test or Die!"
      end
    end

    context "generating random words or phrases" do
      it "will generate random words" do
        expect(Faker::Lorem).to receive(:words).and_return(['random', 'words'])
        set_field_value "~words"
        expect(example.data_for('key')).to have_field_value 'random words'
      end

      it "will default to returning 3 words" do
        set_field_value "~words"
        expect(example.data_for('key')['field'].split.size).to eql 3
      end

      it "will allow you to specify the number of words to generate" do
        set_field_value "~words(4)"
        expect(example.data_for('key')['field'].split.size).to eql 4
      end

      it "will generate a random sentence" do
        expect(Faker::Lorem).to receive(:sentence).and_return("a test sentence")
        set_field_value "~sentence"
        expect(example.data_for('key')).to have_field_value "a test sentence"
      end

      it "will default to returning a minimum of 4 words" do
        set_field_value "~sentence"
        expect(example.data_for('key')['field'].split.size).to be >= 4
      end

      it "will allow you to specify a minimum word count" do
        set_field_value "~sentence(20)"
        expect(example.data_for('key')['field'].split.size).to be >= 20
      end

      it "will generate sentences" do
        expect(Faker::Lorem).to receive(:sentences).and_return(["Here is. A sentence."])
        set_field_value "~sentences"
        expect(example.data_for('key')).to have_field_value "Here is. A sentence."
      end

      it "will default to returning a minimum of 3 sentences" do
        set_field_value "~sentences"
        expect(example.data_for('key')['field'].split('.').size).to be >= 3
      end

      it "will allow you to specify the number of sentences" do
        set_field_value "~sentences(10)"
        expect(example.data_for('key')['field'].split('.').size).to be >= 10
      end

      it "will generate a paragraph" do
        expect(Faker::Lorem).to receive(:paragraphs).and_return(["this is a paragraph"])
        set_field_value "~paragraphs"
        expect(example.data_for('key')).to have_field_value "this is a paragraph"
      end

      it "will default to returning a minimum of 3 paragraphs" do
        set_field_value "~paragraphs"
        expect(example.data_for('key')['field'].split('\n\n').size).to eql 3
      end

      it "will allow you to specify the number of paragraphs" do
        set_field_value "~paragraphs(10)"
        expect(example.data_for('key')['field'].split('\n\n').size).to eql 10
      end

      it "will generate characters" do
        expect(Faker::Lorem).to receive(:characters).and_return("abcdefg")
        set_field_value "~characters"
        expect(example.data_for('key')).to have_field_value "abcdefg"
      end
    end

    context "generating internet values" do
      it "will generate an email address" do
        expect(Faker::Internet).to receive(:email).and_return("tester@testing.com")
        set_field_value "~email_address"
        expect(example.data_for('key')).to have_field_value "tester@testing.com"
      end

      it "will generate a domain name" do
        expect(Faker::Internet).to receive(:domain_name).and_return("testerstories.com")
        set_field_value "~domain_name"
        expect(example.data_for('key')).to have_field_value "testerstories.com"
      end

      it "will generate a user name" do
        expect(Faker::Internet).to receive(:user_name).and_return("test_admin")
        set_field_value "~user_name"
        expect(example.data_for('key')).to have_field_value "test_admin"
      end

      it "will generate a url" do
        expect(Faker::Internet).to receive(:url).and_return("testing.com")
        set_field_value "~url"
        expect(example.data_for('key')).to have_field_value "testing.com"
      end
    end

    context "generating date values" do
      it "will generate today's date" do
        set_field_value "~today"
        expect(example.data_for('key')).to have_field_value Date.today.strftime('%D')
      end

      it "will generate tomorrow's date" do
        set_field_value "~tomorrow"
        tomorrow = Date.today + 1
        expect(example.data_for('key')).to have_field_value tomorrow.strftime('%D')
      end

      it "will generate yesterday's date" do
        set_field_value "~yesterday"
        yesterday = Date.today - 1
        expect(example.data_for('key')).to have_field_value yesterday.strftime('%D')
      end

      it "will generate a date that is some number of days from now" do
        set_field_value "~5.days_from_today"
        the_date = Date.today + 5
        expect(example.data_for('key')).to have_field_value the_date.strftime('%D')
      end

      it "will generate a date that is some number of days ago" do
        set_field_value "~5.days_ago"
        the_date = Date.today - 5
        expect(example.data_for('key')).to have_field_value the_date.strftime('%D')
      end
    end

    context "array generation" do
      it "will be able to generate from arrays" do
        set_field_value ["~'user' + 'name'", 'second']
        expect(example.data_for('key')).to have_field_value ['username', 'second']
      end
    end

    context "undefined generation procedure" do
      it "will fail if a generation method does not exist" do
        set_field_value "~non_existing_method"
        expect { example.data_for('key') }.to raise_error(/non_existing_method/)
      end
    end

    context "undefined values" do
      it "will throw an ArgumentError if values are not in the data file" do
        expect { example.data_for("no_key") }.to raise_error ArgumentError
      end
    end

    context "generating boolean values" do
      it "will resolve true but not generate anything" do
        set_field_value true
        expect(example.data_for('key')).to have_field_value true
      end

      it "will resolve false but not generate anything" do
        set_field_value false
        expect(example.data_for('key')).to have_field_value false
      end
    end

    context "generating numeric values" do
      it "will not generate values for number literals" do
        set_field_value(1)
        expect(example.data_for("key")).to have_field_value 1
      end
    end
  end
end
