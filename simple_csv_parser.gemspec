# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'simple_csv_parser/version'

Gem::Specification.new do |spec|
  spec.name          = "simple_csv_parser"
  spec.version       = SimpleCsvParser::VERSION
  spec.authors       = ["Yuichi TANIKAWA"]
  spec.email         = ["t.yuichi111@gmail.com"]
  spec.summary       = %q{Simple CSV parser based on RFC 4180}
  spec.description   = spec.summary
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
