module Wellness

  # @author Matthew A. Johnston
  class System
    attr_reader :name

    # @param name [String] the name of the system
    def initialize(name)
      @name = name
      @services = Hash.new
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

    # Returns the services that are within this system
    #
    # @return [Hash]
    def services
      @services.dup
    end

    # Checks all of the services
    # @return
    def check
      @services.values.each { |service| service.call }
    end

    # Returns true if the system is healthy, false otherwise
    #
    # @return [Boolean]
    def healthy?
      @services.values.all? { |service| service.healthy? }
    end
  end

end
