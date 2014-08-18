require 'wellness/services/base'

module Wellness
  module Services
    class PostgresService < Base
      dependency do
        require 'pg'
      end

      def initialize(args={})
        @connection_options = {
          host: args[:host],
          port: args[:port],
          dbname: args[:database],
          user: args[:user],
          password: args[:password]
        }
      end

      # @return [Hash]
      def call
        case PG::Connection.ping(@connection_options)
        when PG::Constants::PQPING_NO_ATTEMPT
          ping_failed('no attempt made to ping')
        when PG::Constants::PQPING_NO_RESPONSE
          ping_failed('no response from ping')
        when PG::Constants::PQPING_REJECT
          ping_failed('ping was rejected')
        else
          ping_successful
        end
      end

      private

      # @param message [String] the reason it failed
      # @return [Hash]
      def ping_failed(message)
        {
          'status' => 'UNHEALTHY',
          'details' => {
            'error' => message
          }
        }
      end

      # @return [Hash]
      def ping_successful
        {
          'status' => 'HEALTHY',
          'details' => {
          }
        }
      end
    end
  end
end
