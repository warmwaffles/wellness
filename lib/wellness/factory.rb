module Wellness
  # A simple class that builds the provided class with the provided arguments
  # @author Matthew A. Johnston (warmwaffles)
  class Factory
    def initialize(klass, *args)
      @klass = klass
      @args  = args
    end

    def build
      @klass.new(*@args)
    end
  end
end