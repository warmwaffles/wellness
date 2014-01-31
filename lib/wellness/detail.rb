module Wellness
  # The parent class of all details that need to run.
  #
  # @author Matthew A. Johnston (warmwaffles)
  class Detail
    attr_reader :name, :result

    def initialize(name)
      @name = name
      @result = {}
    end

    def call
      @result = self.check
      self
    end

    # @return [Hash]
    def check
      {}
    end
  end
end