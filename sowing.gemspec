# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sowing/version'

Gem::Specification.new do |spec|
  spec.name          = 'sowing'
  spec.version       = Sowing::VERSION
  spec.authors       = ['kbaba1001']
  spec.email         = ['kbaba1001@gmail.com']

  spec.summary       = %q{seed data handling for Rails apps}
  spec.description   = %q{seed data handling for Rails apps}
  spec.homepage      = 'https://github.com/kbaba1001/sowing'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.12'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'test-unit', '~> 3.2.1'
end