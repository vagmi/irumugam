require 'helper/spec_helper'

describe Server do
  def app
    Server.new
  end
  before do
    ServiceRegistry.cleanup!
    describe_service "My Glorious Service" do
      host "http://testservice"
      end_point "/glorious_service"
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
  it "should serve rack requests" do
    get "/glorious_service/users"
    last_response.ok?.should be_true
    last_response.body.should == [FactoryGirl.attributes_for(:user)].to_json
  end
end
