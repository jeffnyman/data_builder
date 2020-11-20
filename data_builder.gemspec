# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'data_builder/version'

Gem::Specification.new do |spec|
  spec.name          = "data_builder"
  spec.version       = DataBuilder::VERSION
  spec.authors       = ["Jeff Nyman"]
  spec.email         = ["jeffnyman@gmail.com"]

  spec.summary       = %q{Provides expressive data set handling from YAML files.}
  spec.description   = %q{Provides expressive data set handling from YAML files.}
  spec.homepage      = "https://github.com/jeffnyman/data_builder"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", ">= 12.3.3"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rubocop"
  spec.add_development_dependency "pry"

  spec.add_runtime_dependency "data_reader"
  spec.add_runtime_dependency "faker"

  spec.post_install_message = %{
(::) (::) (::) (::) (::) (::) (::) (::) (::) (::) (::) (::)
  DataBuilder #{DataBuilder::VERSION} has been installed.
(::) (::) (::) (::) (::) (::) (::) (::) (::) (::) (::) (::)
  }
end
