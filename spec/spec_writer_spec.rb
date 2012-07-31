require 'helper/spec_helper'
describe SpecWriter do
  before do
    varadha = {name: "Varadha", email: "varadha@thoughtworks.com"}
    stub_request(:get,"http://testservice/glorious_service/users").with(:query=>{}).to_return(:body=>[FactoryGirl.attributes_for(:user)].to_json)
    stub_request(:get,"http://testservice/glorious_service/users/1").with(:query=>{}).to_return(:body=>FactoryGirl.attributes_for(:user).to_json)
    stub_request(:get,"http://testservice/glorious_service/users/1.json").with(:query=>{}).to_return(:body=>FactoryGirl.attributes_for(:user).to_json)
    stub_request(:post,"http://testservice/glorious_service/users.json").with(:query=>{},:body=>varadha).to_return(:body=>varadha.merge({"id"=>22}).to_json, :status=>201)
    stub_request(:put,"http://testservice/glorious_service/users/42.json").with(:query=>{},:body=>varadha).to_return(:body=>varadha.merge({"id"=>42}).to_json, :status=>201)
    $test_object = dup()
    $test_object.should_receive(:teardown).exactly(6).times
    $test_object.should_receive(:setup).exactly(6).times
    $test_object.should_receive(:setup_once).once
    $test_object.should_receive(:teardown_once).once

    ServiceRegistry.cleanup!

    describe_service "My Glorious Service" do
      host "http://testservice"
      end_point "/glorious_service"

      before :all do
        $test_object.setup_once
      end

      after :all do
        $test_object.teardown_once
      end

      before(:each) do
        $test_object.setup
        @path_object = {:id=>42}
      end

      after(:each) do
        $test_object.teardown
      end

      get "/users" do
        status 200
        json [FactoryGirl.attributes_for(:user)]
      end

      get "/users/1.json" do
        status 200
        json({id: 43, name: "Some Name", email: "someemail@example.com"}, :ignore=>[:id])
      end

      get "/users/1.json" do
        status 200
        json({"id" => 42, "name"=>"Some Name", "email"=>"someemail@example.com"}, :ignore=>["id"])
      end

      post "/users.json", :body=>varadha, :type=>:json do
        status 201
        json varadha.merge(:id=>42), :ignore=>[:id]
      end

      put "/users/:id.json", :body=>varadha, :type=>:json do
        status 201
        json varadha.merge(:id=>42), :ignore=>[:id]
        path_object { @path_object }
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
      #formatter.failed_examples.each do |fe|
        #puts fe.metadata[:description_args]
        #puts fe.metadata[:execution_result]
      #end
      formatter.examples.count.should == 6
      formatter.failed_examples.count.should == 1
    end
  end
end
