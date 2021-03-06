# coding: utf-8
# frozen_string_literal: true

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mint/money/version'

Gem::Specification.new do |spec|
  spec.name          = 'mint-money'
  spec.version       = Mint::Money::VERSION
  spec.authors       = ['Renat Ibragimov']
  spec.email         = ['mrak69@gmail.com']

  spec.summary       = 'Manage money with Mint::Money'
  spec.description   = File.read(File.expand_path('../README.md', __FILE__))
  spec.homepage      = 'https://github.com/mpakus/mint-money'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.15'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 0.49'
  spec.add_development_dependency 'pry', '~> 0.10'
end
