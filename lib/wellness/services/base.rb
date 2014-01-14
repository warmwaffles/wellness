module Wellness
  module Services

    # @author Matthew A. Johnston
    class Base
      def initialize(params={})
        @params = params
        @health = false
      end

      # Flags the check as failed
      def failed_check
        @health = false
      end

      # Flags the check as passed
      def passed_check
        @health = true
      end

      def params
        @params.dup
      end

      # Returns true if the service is healthy, otherwise false
      # @return [Boolean]
      def healthy?
        !!@health
      end

      # @return [Hash]
      def call
        @last_check = self.check
      end

      # @return [Hash]
      def check
        {}
      end

      # @return [Hash]
      def last_check
        @last_check || {}
      end
    end

  end
end