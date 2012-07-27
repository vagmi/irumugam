require 'helper/spec_helper'

describe Service do
  before(:each) do
    ServiceRegistry.cleanup!
    @block = Proc.new { 
      end_point "/end_point" 
      before(:each) do
        DB.create_record
      end
      before(:all) do
        DB.create_record
      end
      after(:all) do
        DB.create_record
      end

      after(:each) do
        DB.create_record
      end
    }
    @service = Service.new("Test Service",@block) 
  end
  it "should add contracts" do
    @service.get "/users" do
      status 200
      body ({msg: "Hello world"}.to_json)
    end
    @service.post "/users" do
      status 200
      body ({msg: "Hello world"}.to_json)
    end
    @service.put "/users" do
      status 200
      body ({msg: "Hello world"}.to_json)
    end
    @service.delete "/users" do
      status 200
      body ({msg: "Hello world"}.to_json)
    end
    @service.paths["/end_point/users"].count.should==4
    @service.paths["/end_point/users"].map(&:method).should =~ ["GET", "POST", "PUT", "DELETE"]
  end
  it "should have set the before and after hooks" do
    @service.before_blocks[:each].should_not be_nil
    @service.before_blocks[:all].should_not be_nil
    @service.after_blocks[:each].should_not be_nil
    @service.after_blocks[:all].should_not be_nil
  end
  it "should accept json in the contract content" do
    @service.get "/users.json" do
      status 200
      json [{:name=>"name"}], :ignore=>[:id]
    end
  end
end
