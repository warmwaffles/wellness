module Wellness
  # This is to be put into the Rack environment.
  #
  # @author Matthew A. Johnston
  class Middleware
    def initialize(app, system, options={})
      @app = app
      @system = system
      @options = options
    end

    def health_status_path
      @options[:status_path] || '/health/status'
    end

    def health_details_path
      @options[:details_path] || '/health/details'
    end

    def call(env)
      case env['PATH_INFO']
      when health_status_path
        @system.simple_check
      when health_details_path
        @system.detailed_check
      else
        @app.call(env)
      end
    end
  end
end