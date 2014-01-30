module Wellness
  module Services
    # @author Matthew A. Johnston
    class Base

      # Load dependencies when the class is loaded. This makes putting requires
      # at the top of the file unnecessary. It plays nicely with the
      # auto loader.
      def self.dependency
        yield if block_given?
      end

      # @param params [Hash]
      def initialize(params={})
        @params = params
        @health = false
      end

      # Flags the check as failed
      # @return [FalseClass]
      def failed_check
        @health = false
      end

      # Flags the check as passed
      # @return [TrueClass]
      def passed_check
        @health = true
      end

      # @return [Hash]
      def params
        @params.dup
      end

      # Returns true if the service is healthy, otherwise false
      # @return [TrueClass,FalseClass]
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