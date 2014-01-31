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

      dependency do
        require('redis')
      end

      # @return [Hash]
      def check
        client = build_client
        details = client.info.select { |k, _| KEYS.include?(k) }
        passed(details)
      rescue Redis::BaseError => error
        failed(error)
      rescue Exception => error
        failed(error)
      end

      def build_client
        Redis.new(self.params)
      end

      def passed(details)
        {
          status: 'HEALTHY',
          details: details
        }
      end

      def failed(error)
        {
          status: 'UNHEALTHY',
          details: {
            error: error.message
          }
        }
      end
    end
  end
end
