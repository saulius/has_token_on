$:.push File.expand_path("../lib", __FILE__)
require "has_token_on/version"

Gem::Specification.new do |s|
  s.name        = 'has_token_on'
  s.version     = HasTokenOn::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Saulius Grigaliunas']
  s.email       = ['saulius@ninja.lt']
  s.homepage    = 'https://github.com/sauliusg/has_token_on'
  s.summary     = 'A token generator plugin for Rails 3'
  s.description = 'Simple yet customizable token generator for Rails 3'
  s.licenses = ['MIT']
  s.rubyforge_project = 'has_token_on'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {spec}/*`.split("\n")
  s.extra_rdoc_files = ['README.md']
  s.require_paths = ['lib']

  s.add_dependency 'railties', ['~> 3.0']
  s.add_development_dependency 'simple_uuid'
  s.add_development_dependency 'sqlite3', ['>= 0']
  s.add_development_dependency 'rspec', ['~> 2.0']
  s.add_development_dependency 'mocha', ['~> 0.9.8']
  s.add_development_dependency 'with_model', ['>= 0.1.4']
  s.add_development_dependency 'guard', ['>= 0.3.4']
  s.add_development_dependency 'guard-rspec', ['>= 0']
  s.add_development_dependency 'growl', ['>= 0']
  s.add_development_dependency 'rb-fsevent', ['>= 0']
  s.add_development_dependency 'ruby-debug19', ['>= 0']
  s.add_development_dependency 'mongoid', ['~> 2.0']
  s.add_development_dependency 'bson_ext', ['>= 1.3.1']
end
