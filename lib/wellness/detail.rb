module Wellness
  # The parent class of all details that need to run.
  #
  # @deprecated This is simply here help with migrating
  #
  # @author Matthew A. Johnston (warmwaffles)
  class Detail
    attr_reader :options

    def initialize(options={})
      @options = options
    end

    def call
      self.check
    end

    # @return [Hash]
    def check
      {}
    end
  end
end
