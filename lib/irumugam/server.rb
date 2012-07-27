module Irumugam
  class Server
    def call(env)
      request = Rack::Request.new(env)
      contract = ServiceRegistry.find(request)
      body = contract.contract_body if contract.contract_body
      body ||= contract.contract_json.to_json
      [contract.contract_status, {}, body]
    end
  end

  module RequestMatcher
    def matches?(request)
      request_body = request.body.read      
      request_json = JSON.parse(request_body) if (!request_body.empty? && request.content_type=="application/json")
      request.request_method==self.method && request.params==self.params && (request_json.nil? ? true : (request_json == self.contract_json.stringify_keys))
    end
  end

  Contract.instance_eval { include RequestMatcher }

end
