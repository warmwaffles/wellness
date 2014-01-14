module Wellness

  # @author Matthew A. Johnston
  class System
    attr_reader :name

    attr_accessor :details

    # @param name [String] the name of the system
    def initialize(name)
      @name = name
      @services = Hash.new
      @details = Hash.new
    end

    # Add a service to this system
    #
    # @param name [String, Symbol] the name of the service
    # @param service [Wellness::Service] the service you wish to add
    def add_service(name, service)
      @services[name] = service
    end

    # Remove a service from this system
    #
    # @param name [String, Symbol]
    # @return [Wellness::Service] the service removed, else nil
    def remove_service(name)
      @services.delete(name)
    end

    # Checks all of the services
    # @return
    def check
      @services.values.each { |service| service.call }
      healthy?
    end

    # Returns true if the system is healthy, false otherwise
    #
    # @return [Boolean]
    def healthy?
      @services.values.all? { |service| service.healthy? }
    end

    def to_json(*)
      dependencies = Hash.new

      @services.each do |name, service|
        dependencies[name] = service.last_check
      end

      data = {
        status: (healthy? ? 'HEALTHY' : 'UNHEALTHY'),
        details: @details,
        dependencies: dependencies
      }

      data.to_json
    end
  end

end
