module Wellness
  # @author Matthew A. Johnston (warmwaffles)
  class System
    attr_reader :name

    # @param name [String] the name of the system
    def initialize(name)
      @name = name
      @services = []
      @details = []
      @mutex = Mutex.new
    end

    def use(klass, *args)
      @mutex.synchronize do
        factory = Factory.new(klass, *args)
        if klass <= Wellness::Services::Base
          @services << factory
        else
          @details << factory
        end
      end
    end

    def detailed_check
      report = build_report
      [report.status_code, { 'Content-Type' => 'application/json' }, [report.detailed.to_json]]
    end

    def simple_check
      report = build_report
      [report.status_code, { 'Content-Type' => 'application/json' }, [report.simple.to_json]]
    end

    def build_report
      @mutex.synchronize do
        Wellness::Report.new(services, details)
      end
    end

    def services
      Hash[@services.map(&:build).map { |s| [s.name, s.check] }]
    end

    def details
      Hash[@details.map(&:build).map { |d| [d.name, d.call] }]
    end
  end
end
