require 'rspec'
module Irumugam
  class SpecWriter
    def self.create_example_groups
      #Process GET Requests
      ServiceRegistry.instance.services.values.each do |service|
        eg = RSpec::Core::ExampleGroup.describe("#{service.name} specs") do
          before :all, &(service.before_blocks[:all]) if service.before_blocks[:all]
          before :each, &(service.before_blocks[:each]) if service.before_blocks[:each]
          after :all, &(service.after_blocks[:all]) if service.after_blocks[:all]
          after :each, &(service.after_blocks[:each]) if service.after_blocks[:each]
          ServiceRegistry.instance.paths_for(service.name).each do |contract|
            it "should succeed for GET #{contract.path}" do
              response = HTTParty.get(contract.test_host + contract.path, :query=>contract.params) 
              response.code.should==contract.contract_status
              response.body.should==contract.contract_body
            end
          end
        end
        eg.register
      end
    end
  end
end
