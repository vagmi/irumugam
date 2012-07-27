require 'helper/spec_helper'

describe Server do
  def app
    Server.new
  end
  before do
    ServiceRegistry.cleanup!
    varadha = {name: "Varadha", email:"varadha@thoughtworks.com"}
    @varadha = varadha
    describe_service "My Glorious Service" do
      host "http://testservice"
      end_point "/glorious_service"
      get "/users" do
        status 200
        json [FactoryGirl.attributes_for(:user)]
      end
      get "/users/1" do
        status 200
        body ({name: "Some Other Name", email: "email@example.com"}).to_json
      end
      post "/users.json", :body=>{name: "vagmi", email: "vagmi@thoughtworks.com"}, :type=>:json do
        status 201
        json({name: "vagmi", email: "vagmi@thoughtworks.com"}.merge(:id=>23), :ignore=>[:id])
      end
      post "/users.json", :body=>varadha, :type=>:json do
        status 201
        json(varadha.merge(:id=>23), :ignore=>[:id])
      end
    end
    
  end
  it "should serve rack requests" do
    get "/glorious_service/users"
    last_response.ok?.should be_true
    last_response.body.should == [FactoryGirl.attributes_for(:user)].to_json
  end
  it "should serve post requests with a matching body" do
    post "/glorious_service/users.json", @varadha.to_json, {'CONTENT_TYPE'=>'application/json'}
    last_response.status.should == 201
    JSON.parse(last_response.body).should == @varadha.stringify_keys.merge("id"=>23)
  end
  it "should serve a non-json request" do
    get "/glorious_service/users/1"
    last_response.ok?.should be_true
    last_response.body.should == ({name: "Some Other Name", email: "email@example.com"}).to_json
  end
end
