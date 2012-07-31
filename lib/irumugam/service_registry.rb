require 'singleton'
module Irumugam
  class ServiceRegistry
    include Singleton
    attr_accessor :services, :paths

    def initialize
      @paths ||= {}
      @services ||= {}
    end

    def cleanup!
      @paths = {}
      @services = {}
    end

    def find(request)
      req_body = request.body.read
      paths.values.flatten.select { |c| c.matches?(request, req_body) }.first
    end

    def paths_for(service_name)
      paths.values.flatten.select { |c| c.service.name==service_name }
    end

    def self.cleanup!
      instance.cleanup!
    end
    
    def self.desc(name,&block)
      instance.services[name] = Service.new(name, block)
    end
    
    def self.find(request)
      instance.find(request)
    end
  end
end
