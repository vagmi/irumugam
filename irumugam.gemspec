# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "irumugam/version"

Gem::Specification.new do |s|
  s.name        = "irumugam"
  s.version     = Irumugam::VERSION
  s.authors     = ["Shakir Shakiel", "Vagmi Mudumbai", "Lokesh D"]
  s.email       = ["shakiras@thoughtworks.com", "vagmimud@thoughtworks.com", "lokeshd@thoughtworks.com"]
  s.homepage    = ""
  s.summary     = %q{Describe service contracts that act both as a spec and a mock}
  s.description = %q{Describe service contracts that act both as a spec and a mock}

  s.rubyforge_project = "irumugam"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency "webmock"
  s.add_development_dependency "factory_girl"
  s.add_development_dependency "rack-test"
  s.add_development_dependency "rake"
  s.add_runtime_dependency "rspec"
  s.add_runtime_dependency "rack"
  s.add_runtime_dependency "httparty"
  s.add_runtime_dependency "json"
end
