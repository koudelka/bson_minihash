# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bson_minihash/version'

Gem::Specification.new do |spec|
  spec.name          = "bson_minihash"
  spec.version       = BSONMiniHash::VERSION
  spec.authors       = ["Michael Shapiro"]
  spec.email         = ["koudelka@ryoukai.org"]
  spec.summary       = "Stores hashes in a BSON 'packed' format."
  spec.description   = "Saves space by storing strings with limited character sets as packed BSON BinData."
  spec.homepage      = 'https://github.com/koudelka/bson_minihash'
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"

  spec.add_development_dependency "bson"
  spec.add_development_dependency "moped"
end
