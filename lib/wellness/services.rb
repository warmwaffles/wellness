module Wellness
  module Services
  end
end

require 'wellness/services/base'
require 'wellness/services/postgres_service'
require 'wellness/services/redis_service'
require 'wellness/services/sidekiq_service'
