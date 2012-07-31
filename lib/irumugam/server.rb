module Irumugam
  class Server
    def call(env)
      request = Rack::Request.new(env)
      contract = ServiceRegistry.find(request)
      body = contract.contract_body if contract.contract_body
      body ||= contract.contract_json.to_json
      content_type = "application/json" if contract.contract_json
      [contract.contract_status, {"Content-Type"=>content_type || "text/plain" }, [body]]
    end
  end
end
