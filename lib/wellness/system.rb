require 'wellness/service'

module Wellness
  # @author Matthew A. Johnston (warmwaffles)
  class System
    attr_reader :name, :services, :details

    # @param name [String] the name of the system
    def initialize(name)
      @name     = name
      @services = {}
      @details  = {}
    end

    def add_service(name, service, options={})
      @services[name] = Wellness::Service.new(service, options)
    end

    def add_detail(name, detail)
      @details[name] = detail
    end
  end
end
