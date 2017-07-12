# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cadmus_navbar/version'

Gem::Specification.new do |spec|
  spec.name          = "cadmus_navbar"
  spec.version       = CadmusNavbar::VERSION
  spec.authors       = ["Nat Budin"]
  spec.email         = ["natbudin@gmail.com"]

  spec.summary       = %q{Adminable navigation bars for Cadmus sites}
  spec.description   = %q{Adds models and renderers for navigation bars to the Cadmus micro-CMS}
  spec.homepage      = "https://github.com/nbudin/cadmus_navbar"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "rails", ">= 5.0.0"
  spec.add_dependency "cadmus"
  spec.add_dependency "acts_as_list"

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest"
end
