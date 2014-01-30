module Wellness
  # The parent class of all details that need to run.
  #
  # @author Matthew A. Johnston (warmwaffles)
  class Detail
    attr_reader :name

    def initialize(name)
      @name = name
    end

    # @return [Hash]
    def call
      {}
    end
  end
end