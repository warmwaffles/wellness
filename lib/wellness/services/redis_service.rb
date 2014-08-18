require 'wellness/services/base'

module Wellness
  module Services
    class RedisService < Base
      KEYS = [
        'used_memory_human',
        'connected_clients',
        'keyspace_misses',
        'keyspace_hits',
        'evicted_keys',
        'expired_keys',
        'sync_partial_err',
        'sync_partial_ok',
        'sync_full',
        'rejected_connections',
        'total_commands_processed',
        'total_connections_received',
        'uptime_in_seconds',
        'uptime_in_days'
      ]

      def initialize(args={})
        @params = args
      end

      # @return [Hash]
      def call
        client  = Redis.new(@params)
        details = client.info.select { |k, _| KEYS.include?(k) }
        client.disconnect

        {
          'status' => 'HEALTHY',
          'details' => details
        }
      rescue Redis::BaseError => error
        failed(error)
      rescue Exception => error
        failed(error)
      end

      def failed(error)
        {
          'status' => 'UNHEALTHY',
          'details' => {
            'error' => error.message
          }
        }
      end
    end
  end
end
