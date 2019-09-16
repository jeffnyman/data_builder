require "data_builder/generation_date"
require "data_builder/generation_standard"

module DataBuilder
  class Generation
    include DateGeneration
    include StandardGeneration

    def initialize(parent)
      @parent = parent
    end
  end
end
