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

      def check
        client = Redis.new(self.params)
        details = client.info.select { |k, _| KEYS.include?(k) }

        passed_check
        {
          status: 'HEALTHY',
          details: details
        }
      rescue Redis::BaseError => error
        failed_check
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
