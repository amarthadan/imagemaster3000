# coding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'imagemaster3000/version'

Gem::Specification.new do |spec|
  spec.name          = 'imagemaster3000'
  spec.version       = Imagemaster3000::VERSION
  spec.authors       = ['Michal Kimle']
  spec.email         = ['kimle.michal@gmail.com']

  spec.summary       = 'Downloading and slight modification of cloud images'
  spec.description   = 'Downloading and slight modification of cloud images'
  spec.homepage      = 'https://github.com/Misenko/imagemaster3000'
  spec.license       = 'Apache License, Version 2.0'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.15'
  spec.add_development_dependency 'git', '~> 1.3'
  spec.add_development_dependency 'rake', '~> 12.0'
  spec.add_development_dependency 'rspec', '~> 3.5'
  spec.add_development_dependency 'rubocop', '~> 0.48'
  spec.add_development_dependency 'rubocop-rspec', '~> 1.15'
  spec.add_development_dependency 'simplecov', '~> 0.12'
  spec.add_development_dependency 'pry', '~> 0.10'
  spec.add_development_dependency 'vcr', '~> 3.0'
  spec.add_development_dependency 'webmock', '~> 3.0'

  spec.add_runtime_dependency 'thor', '~> 0.19'
  spec.add_runtime_dependency 'yell', '~> 2.0'
  spec.add_runtime_dependency 'settingslogic', '~> 2.0'
  spec.add_runtime_dependency 'activesupport', '>= 4.0', '< 6.0'
  spec.add_runtime_dependency 'tilt', '~> 2.0'
  spec.add_runtime_dependency 'gpgme', '~> 2.0'
  spec.add_runtime_dependency 'mixlib-shellout', '~> 2.2'
  spec.add_runtime_dependency 'json-schema', '~> 2.8'

  spec.required_ruby_version = '>= 2.2.0'
end
