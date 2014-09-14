# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'uber/version'

Gem::Specification.new do |spec|
  spec.name          = "uber"
  spec.version       = Uber::Version
  spec.authors       = ["Dingding Ye"]
  spec.email         = ["yedingding@gmail.com"]
  spec.summary       = %q{The Uber Ruby Gem.}
  spec.description   = %q{A Ruby interface to the Uber API.}
  spec.homepage      = "https://github.com/sishen/uber-ruby"
  spec.license       = "MIT"

  spec.files = %w(LICENSE.txt README.md Rakefile uber-ruby.gemspec)
  spec.files += Dir.glob('lib/**/*.rb')
  spec.files += Dir.glob('test/**/*')
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = Dir.glob('test/**/*')
  spec.require_paths = ["lib"]
  spec.required_rubygems_version = '>= 1.3.5'

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake", '~> 0'

  spec.add_dependency 'oauth2', '~> 1.0.0', '>= 1.0.0'
  spec.add_dependency 'faraday', '~> 0.9.0', '>= 0.9.0'
  spec.add_dependency 'http', '~> 0.5.0', '>= 0.5.0'
  spec.add_dependency 'http_parser.rb', '~> 0.6.0', '>= 0.6.0'
  spec.add_dependency 'json', '~> 1.8'
end
