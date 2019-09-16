module DataBuilder
  module StandardGeneration
    attr_reader :parent
    attr_reader :data_builder_data_hash

    def full_name
      Faker::Name.name
    end

    def first_name
      Faker::Name.first_name
    end

    def last_name
      Faker::Name.last_name
    end

    def name_prefix
      Faker::Name.prefix
    end

    def name_suffix
      Faker::Name.suffix
    end

    def title
      Faker::Name.title
    end

    def street_address(include_secondary = false)
      Faker::Address.street_address(include_secondary: include_secondary)
    end

    def secondary_address
      Faker::Address.secondary_address
    end

    def city
      Faker::Address.city
    end

    def state
      Faker::Address.state
    end

    def state_abbr
      Faker::Address.state_abbr
    end

    def zip_code
      Faker::Address.zip
    end

    def country
      Faker::Address.country
    end

    def credit_card_number
      Faker::Business.credit_card_number
    end

    def credit_card_type
      Faker::Business.credit_card_type
    end

    def phone_number
      value = Faker::PhoneNumber.phone_number
      remove_extension(value)
    end

    def cell_phone
      value = Faker::PhoneNumber.cell_phone
      remove_extension(value)
    end

    def company_name
      Faker::Company.name
    end

    def catch_phrase
      Faker::Company.catch_phrase
    end

    def words(number = 3)
      Faker::Lorem.words(number: number).join(' ')
    end

    def sentence(min_word_count = 4)
      Faker::Lorem.sentence(word_count: min_word_count)
    end

    def sentences(sentence_count = 3)
      Faker::Lorem.sentences(number: sentence_count).join(' ')
    end

    def paragraphs(paragraph_count = 3)
      Faker::Lorem.paragraphs(number: paragraph_count).join('\n\n')
    end

    def characters(character_count = 255)
      Faker::Lorem.characters(number: character_count)
    end

    def email_address(name = nil)
      Faker::Internet.email(name: name)
    end

    def domain_name
      Faker::Internet.domain_name
    end

    def user_name
      Faker::Internet.user_name
    end

    def url
      Faker::Internet.url
    end

    alias db_first_name first_name
    alias db_full_name full_name
    alias db_last_name last_name
    alias db_name_prefix name_prefix
    alias db_name_suffix name_suffix
    alias db_title title
    alias db_street_address street_address
    alias db_secondary_address secondary_address
    alias db_city city
    alias db_state state
    alias db_state_abbr state_abbr
    alias db_zip_code zip_code
    alias db_country country
    alias db_credit_card_number credit_card_number
    alias db_credit_card_type credit_card_type
    alias db_phone_number phone_number
    alias db_cell_phone cell_phone
    alias db_company_name company_name
    alias db_catch_phrase catch_phrase
    alias db_words words
    alias db_sentence sentence
    alias db_sentences sentences
    alias db_paragraphs paragraphs
    alias db_characters characters
    alias db_email_address email_address
    alias db_domain_name domain_name
    alias db_user_name user_name
    alias db_url url

    def randomize(value)
      case value
        when Array then value[rand(value.size)]
        when Range then rand((value.last + 1) - value.first) + value.first
        else value
      end
    end

    def sequential(value)
      index = index_variable_for(value)
      index = (index ? index + 1 : 0)
      index = 0 if index == value.length
      set_index_variable(value, index)
      value[index]
    end

    def mask(value)
      result = ''

      value.each_char do |ch|
        result += case ch
                    when '#' then randomize(0..9).to_s
                    when 'A' then ('A'..'Z').to_a[rand(26)]
                    when 'a' then ('a'..'z').to_a[rand(26)]
                    else ch
                  end
      end

      result
    end

    alias db_randomize randomize
    alias db_sequential sequential
    alias db_mask mask

    private

    def process(value)
      # rubocop:disable Security/Eval
      eval value
      # rubocop:enable Security/Eval
    end

    def remove_extension(phone)
      index = phone.index('x')
      phone = phone[0, (index - 1)] if index
      phone
    end

    def set_index_variable(ary, value)
      index_hash[index_name(ary)] = value
    end

    def index_variable_for(ary)
      value = index_hash[index_name(ary)]
      index_hash[index_name(ary)] = -1 unless value
      index_hash[index_name(ary)]
    end

    def index_hash
      dh = data_hash[parent]
      data_hash[parent] = {} unless dh
      data_hash[parent]
    end

    def index_name(ary)
      "#{ary[0]}#{ary[1]}_index".gsub(' ', '_').downcase
    end

    def data_hash
      data_builder_data_hash || {}
    end
  end
end
