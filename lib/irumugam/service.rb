module Irumugam
  class Service
    attr_accessor :name, :block, :rest_end_point, :paths, :test_host, :before_blocks, :after_blocks
    def initialize(name, service_block)
      @name, @block = name, service_block
      @before_blocks = {} 
      @after_blocks = {}
      @paths = ServiceRegistry.instance.paths
      instance_eval &service_block
    end
    def before(type=:each, &before_block)
      before_blocks[type] = before_block
    end
    def after(type=:each, &after_block)
      after_blocks[type] = after_block
    end
    def end_point(name)
      @rest_end_point = name
    end
    def host(val)
      @test_host=val
    end
    ["GET", "POST", "PUT", "DELETE"].each do |verb|
      define_method(verb.downcase) do |path, options={}, &block|
        http_method(verb, @rest_end_point+path, options, block)
      end
    end
      
    def http_method(method,path,options,contract_block)
      defaults = {:accept=>"application/json", 
                  :method=>method, 
                  :path=>path,
                  :test_host => @test_host,
                  :params=>{}, 
                  :block=>contract_block,
                  :service=>self}
      defaults.merge!(options)
      paths[path] ||= []
      paths[path] << Contract.new(defaults)
    end
  end
end
