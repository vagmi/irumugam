module Irumugam
  class Contract
    attr_accessor :method, :path, :service, :accept,:block, :contract_status, :contract_body, :test_host, :params
    def initialize(options={})
      @method = options[:method]
      @path = options[:path]
      @test_host = options[:test_host]
      @params = options[:params]
      @accept = options[:accept]
      @service = options[:service]
      instance_eval &(options[:block])
    end
    def status(val)
      @contract_status = val
    end
    def body(val)
      @contract_body = val
    end
  end
end
