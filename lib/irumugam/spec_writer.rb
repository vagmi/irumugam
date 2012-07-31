require 'rspec'
module Irumugam

  module RequestMethods
    def perform_request(options)
      path_object = options.delete(:path_object)
      if(path_object)
        path_object.each do |k,v|
          self.path.gsub!(":#{k}",v.to_s)
        end
      end
      options[:query]=self.params if self.params
      if self.request_body
        if self.request_type == :json
          options[:body]=self.request_body.to_json
          options[:headers]={"Content-Type"=>"application/json"}
        else
          options[:body]=self.request_body
        end
      end
      response = HTTParty.send(self.method.downcase.to_sym,self.test_host + self.path, options) 
    end
  end

  Contract.class_eval { include RequestMethods }

  class SpecWriter
    def self.create_example_groups
      ServiceRegistry.instance.services.values.each do |service|

        eg = RSpec::Core::ExampleGroup.describe("#{service.name} specs") do
          before :all, &(service.before_blocks[:all]) if service.before_blocks[:all]
          before :each, &(service.before_blocks[:each]) if service.before_blocks[:each]
          after :all, &(service.after_blocks[:all]) if service.after_blocks[:all]
          after :each, &(service.after_blocks[:each]) if service.after_blocks[:each]

          ServiceRegistry.instance.paths_for(service.name).each do |contract|
            it "#{contract.method} #{contract.path} should return with #{contract.contract_status}" do
              path_object = self.instance_eval(&contract.path_object_block) if contract.path_object_block
              response = contract.perform_request(:path_object=>path_object)
              response.code.should==contract.contract_status
              contract.prepare_response(response.body).should == contract.json_for_spec if contract.contract_json
              response.body.should == contract.contract_body if contract.contract_body
            end
          end
        end
        eg.register

      end
    end
  end
end
