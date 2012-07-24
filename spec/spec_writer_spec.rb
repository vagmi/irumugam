require 'helper/spec_helper'
describe SpecWriter do
  before do
    stub_request(:get,"http://testservice/glorious_service/users").with(:query=>{}).to_return(:body=>[FactoryGirl.attributes_for(:user)].to_json)
    stub_request(:get,"http://testservice/glorious_service/users/1").with(:query=>{}).to_return(:body=>FactoryGirl.attributes_for(:user).to_json)
    $test_object = dup()
    $test_object.should_receive(:teardown).twice
    $test_object.should_receive(:setup).twice

    ServiceRegistry.cleanup!

    describe_service "My Glorious Service" do
      host "http://testservice"
      end_point "/glorious_service"

      before(:each) do
        $test_object.setup
      end

      after(:each) do
        $test_object.teardown
      end

      get "/users" do
        status 200
        body [FactoryGirl.attributes_for(:user)].to_json
      end

      get "/users/1" do
        status 200
        body ({name: "Some Other Name", email: "email@example.com"}).to_json
      end
    end
  end

  it "should define specs for the above services" do
    sandboxed do
      formatter = RSpec::Core::Formatters::BaseFormatter.new(nil)
      reporter = get_reporter(formatter)
      register_with_rspec!
      RSpec.world.example_groups.count.should == 1
      RSpec.world.example_groups.first.run(reporter)
      formatter.examples.count.should == 2
      formatter.failed_examples.count.should == 1
    end
  end
end
