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

      def initialize(args={})
      end

      def call
        {
          'status' => 'HEALTHY'
        }
      end
    end
  end
end
