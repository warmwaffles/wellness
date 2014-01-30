module Wellness
  module Services
    autoload :Base,            'wellness/services/base'
    autoload :PostgresService, 'wellness/services/postgres_service'
    autoload :RedisService,    'wellness/services/redis_service'
    autoload :SidekiqService,  'wellness/services/sidekiq_service'
  end
end
