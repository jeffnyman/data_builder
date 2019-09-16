module DataBuilder
  module DateGeneration
    def today(format = '%D')
      Date.today.strftime(format)
    end

    def tomorrow(format = '%D')
      tomorrow = Date.today + 1
      tomorrow.strftime(format)
    end

    def yesterday(format = '%D')
      yesterday = Date.today - 1
      yesterday.strftime(format)
    end

    def month
      randomize(Date::MONTHNAMES[1..-1])
    end

    def month_abbr
      randomize(Date::ABBR_MONTHNAMES[1..-1])
    end

    def day_of_week
      randomize(Date::DAYNAMES)
    end

    def day_of_week_abbr
      randomize(Date::ABBR_DAYNAMES)
    end

    alias db_today today
    alias dn_tomorrow tomorrow
    alias db_yesterday yesterday
    alias db_month month
    alias db_month_abbr month_abbr
    alias db_day_of_week day_of_week
    alias db_day_of_week_abbr day_of_week_abbr
  end
end
