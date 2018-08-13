# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'coinmate/version'

Gem::Specification.new do |spec|
  spec.name          = "coinmate"
  spec.version       = Coinmate::VERSION
  spec.authors       = ["Kamil Kukura"]
  spec.email         = ["kamil.kukura@pentatri.cz"]

  spec.summary       = "Client for CoinMate.io bitcoin exchange"
  spec.description   = "Provides interface for API requests to both public and private data."
  spec.homepage      = "https://github.com/kamk/coinmate"
  spec.license       = "MIT"


  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "activemodel", ">= 5.0"

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 12.0"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "webmock"
  spec.add_development_dependency "vcr"
  spec.add_development_dependency "pry"
end
