module Wellness
  module Services
    # @author Matthew A. Johnston
    class Base
      attr_reader :params, :result, :name

      # Load dependencies when the class is loaded. This makes putting requires
      # at the top of the file unnecessary. It plays nicely with the
      # auto loader.
      def self.dependency
        yield if block_given?
      end

      # @param params [Hash]
      def initialize(name, params={})
        @name = name
        @params = params
        @result = {}
      end

      # Returns true if the service is healthy, otherwise false
      # @return [TrueClass,FalseClass]
      def healthy?
        @result.fetch(:status, 'UNHEALTHY') == 'HEALTHY'
      end

      def passed_check
        warn('#passed_check has been deprecated')
      end

      def failed_check
        warn('#failed_check has been deprecated')
      end

      # @return [Wellness::Services::Base]
      def call
        @result = self.check
        self
      end

      # @return [Hash]
      def check
        {
          status: 'UNHEALTHY'
        }
      end
    end
  end
end