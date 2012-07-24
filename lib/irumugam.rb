require 'json'
require 'httparty'
require 'rack'
require "irumugam/version"
require "irumugam/contract"
require "irumugam/service"
require "irumugam/service_registry"
require "irumugam/spec_writer"
require "irumugam/server"

module Irumugam
  def describe_service(*args, &block)
    ServiceRegistry.desc(*args,&block)
  end
  def register_with_rspec!
    SpecWriter.create_example_groups
  end
end
