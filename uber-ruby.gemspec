# coding: utf-8
# frozen_string_literal: true
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "uber/version"

Gem::Specification.new do |spec|
  spec.name          = "uber-ruby"
  spec.version       = Uber::Version
  spec.authors       = ["Dingding Ye", "Christopher EnyTC"]
  spec.email         = ["yedingding@gmail.com", "chris@enytc.com"]
  spec.summary       = "Uber SDK for Ruby."
  spec.description   = "A Ruby interface to the Uber API."
  spec.homepage      = "https://github.com/sishen/uber-ruby"
  spec.license       = "MIT"

  spec.files = %w(LICENSE.txt README.md Rakefile uber-ruby.gemspec)
  spec.files += Dir.glob("lib/**/*.rb")
  spec.files += Dir.glob("test/**/*")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = Dir.glob("test/**/*")
  spec.require_paths = ["lib"]
  spec.required_rubygems_version = ">= 1.3.5"

  spec.add_development_dependency "bundler",                   "~> 1.5"
  spec.add_development_dependency "rake",                      "~> 0"
  spec.add_development_dependency "webmock",                   "~> 1.21.0"
  spec.add_development_dependency "rspec",                     "~> 3.3.0"
  spec.add_development_dependency "codeclimate-test-reporter", "~> 0.6"

  spec.add_dependency "faraday", "~> 0.9.0"
  spec.add_dependency "json", "~> 1.8"
end
