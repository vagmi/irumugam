# Irumugam

[![Build Status](https://secure.travis-ci.org/vagmi/irumugam.png?branch=master)](http://travis-ci.org/vagmi/irumugam)

Irumugam - The two faced framework helps you setup a DSL for describing services. The one face helps you test the services using RSpec while the other runs it as a mock for consuming them.

To include irumugam in your project, add it to your `Gemfile`

    gem 'irumugam'

## Usage

To you can describe a service this way using irumugam

    # service.rb
    include Irumugam
    
    describe_service "My Glorious Service" do
      host "http://testserver"
      end_point "/cart-service"

      before(:each) do
        #do setup stuff
      end

      after(:each) do
        #do teardown stuff
      end

      get "/orders" do
        status 200
        body [FactoryGirl.attributes_for(:order)].to_json
      end

      get "/orders/1" do
        status 200
        body ({name: "Some Name", quantity: 500}).to_json
      end
    end

    register_with_rspec!

You can now run this as a spec as.

    $ rspec service.rb

You can also run this as a mock server by wiring it with config.ru

    # config.ru
    require './service.rb'

    run Irumugam::Server.new

You can run the server with a rack compatible server like `thin`.

    $ thin -R config.ru start

You can then access the mock service with the following.

    $ curl http://localhost:3000/cart-service/orders/1
