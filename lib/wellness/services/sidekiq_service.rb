module Wellness
  module Services

    # @author Matthew A. Johnston
    class SidekiqService < Wellness::Services::Base
      KEYS = %w(redis_stats uptime_in_days connected_clients used_memory_human used_memory_peak_human)

      def check
        sidekiq_stats = Sidekiq::Stats.new
        queue = Sidekiq::Queue.new
        redis = Redis.new(host: params[:redis_host])
        redis_stats = redis.info.select { |k, _| KEYS.include?(k) }
        workers_size = redis.scard("workers").to_i

        passed_check
        {
          status: 'HEALTHY',
          details: {
            processed: sidekiq_stats.processed,
            failed: sidekiq_stats.failed,
            busy: workers_size,
            enqueued: sidekiq_stats.enqueued,
            scheduled: sidekiq_stats.scheduled_size,
            retries: sidekiq_stats.retry_size,
            default_latency: queue.latency,
            redis: redis_stats
          }
        }
      rescue => error
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