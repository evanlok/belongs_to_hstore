# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'belongs_to_hstore/version'

Gem::Specification.new do |spec|
  spec.name          = "belongs_to_hstore"
  spec.version       = BelongsToHstore::VERSION
  spec.authors       = ["Evan Lok"]
  spec.email         = ["elok45@gmail.com"]
  spec.description   = %q{Allows hstore columns to store belongs_to association foreign keys with the same functionality as the default belongs_to}
  spec.summary       = %q{Allows hstore columns to store belongs_to associations}
  spec.homepage      = "https://github.com/evanlok/belongs_to_hstore"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "activerecord", ">= 3.1"
  spec.add_development_dependency "bundler", "~> 1.3"
end
