require 'helper/spec_helper'

describe ServiceRegistry do
  before(:each) do
    ServiceRegistry.cleanup!
    ServiceRegistry.desc "Auth Service" do
      end_point "/mount_point"
      host "http://testhost"
      get "/path" do
        #expectations
      end
      get "/some_other/path" do
      end
    end
  end
  it "should have a service called Auth Service" do
    service = ServiceRegistry.instance.services["Auth Service"]
    service.should_not be_nil
    service.test_host.should == "http://testhost"
    service.rest_end_point.should == "/mount_point"
  end
  it "should find a contract given a url pattern" do
    contract = ServiceRegistry.find(Rack::Request.new(Rack::MockRequest.env_for("http://testhost/mount_point/path")))
    contract.should_not be_nil
    contract.path.should == "/mount_point/path"
  end
end
