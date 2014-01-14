module Wellness

  # @author Matthew A. Johnston
  class Service
    attr_accessor :healthy

    # Returns true if the service is healthy, otherwise false
    # @return [Boolean]
    def healthy?
      !!@healthy
    end

    # @return [Hash]
    def call
      @healthy = false
      {}
    end
  end

end
