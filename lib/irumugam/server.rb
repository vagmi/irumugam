module Irumugam
  class Server
    def call(env)
      request = Rack::Request.new(env)
      contract = ServiceRegistry.find(request)
      [contract.contract_status, {}, contract.contract_body]
    end
  end
end
