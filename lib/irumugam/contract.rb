module Irumugam
  class Contract
    attr_accessor :method, :path, :service, :accept,:block, :contract_status, :contract_body, :test_host, :params, :contract_json, :contract_json_ignore
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

    def json(val,options={})
      @contract_json = val
      @contract_json_ignore = options.delete(:ignore) || []
    end

    def json_for_spec
      prepare_response(contract_json)
    end
    
    def prepare_response(response)
      response = JSON.parse(response) if response.is_a?(String)
      spec_json = response.clone
      spec_json.map{ |hsh| process_hash(hsh) } if spec_json.is_a?(Array)
      process_hash(spec_json) if spec_json.is_a?(Hash)
      spec_json
    end

    private
    def process_hash(hsh)
      hsh.stringify_keys!
      self.contract_json_ignore.map(&:to_s).each { |key| hsh.delete(key) }
      hsh
    end
  end
end
