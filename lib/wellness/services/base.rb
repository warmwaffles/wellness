module Wellness
  module Services
    # @author Matthew A. Johnston
    class Base
      attr_reader :params

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
        @mutex = Mutex.new
      end

      # Flags the check as failed
      # @return [FalseClass]
      def failed_check
        @mutex.synchronize do
          @health = false
        end
      end

      # Flags the check as passed
      # @return [TrueClass]
      def passed_check
        @mutex.synchronize do
          @health = true
        end
      end

      # Returns true if the service is healthy, otherwise false
      # @return [TrueClass,FalseClass]
      def healthy?
        @mutex.synchronize do
          !!@health
        end
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
        @mutex.synchronize do
          @last_check ||= {}
        end
      end
    end
  end
end