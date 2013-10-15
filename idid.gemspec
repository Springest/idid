# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'idid/version'

Gem::Specification.new do |gem|
  gem.name          = "idid"
  gem.version       = Idid::VERSION
  gem.authors       = ["Wouter de Vos"]
  gem.email         = ["wrdevos@gmail.com"]
  gem.description   = %q{A Ruby CLI for iDoneThis}
  gem.summary       = %q{Post to iDoneThis from your command line.}
  gem.homepage      = "https://github.com/foxycoder/idid"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rspec', '~> 2.12.0'
  gem.add_development_dependency 'travis-lint'

  gem.add_runtime_dependency 'mail', '~> 2.5.3'
end
