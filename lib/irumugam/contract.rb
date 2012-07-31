module Irumugam
  class Contract
    attr_accessor :method, :path, :service, :accept,:block, :contract_status, :contract_body, :test_host, :params, :contract_json, :contract_json_ignore, :request_body, :request_type, :path_object_block
    def initialize(options={})
      @method = options[:method]
      @path = options[:path]
      @test_host = options[:test_host]
      @params = options[:params]
      @request_body = options[:body]
      @request_type = options[:type]
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
    
    def path_object(&po_block)
      @path_object_block = po_block
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
    def path_match?(request)
      match_pattern = /(\:\w+)/
      replace_pattern = /(\w+)/
      path_patterns = self.path.split("/").map { |part|
        part.index(":") ? Regexp.new(part.gsub(match_pattern, replace_pattern.source)) : /#{part}/
      }
      return false unless request.path.split("/").count==path_patterns.count
      path_patterns.each_index do |idx|
        return false unless path_patterns[idx]=~request.path.split("/")[idx]
      end
      true
    end
    def matches?(request, req_body)
      return false if !req_body.empty? ^ !self.request_body.nil?
      request_json = JSON.parse(req_body) if (!req_body.empty? && request.content_type=="application/json")
      result = path_match?(request) && 
        request.request_method==self.method && 
        request.params==self.params && 
        (request_json.nil? ? true : (request_json == self.request_body.stringify_keys))
      result
    end


    private
    def process_hash(hsh)
      hsh.stringify_keys!
      self.contract_json_ignore.map(&:to_s).each { |key| hsh.delete(key) }
      hsh
    end
  end
end
