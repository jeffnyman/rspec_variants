# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rspec/variants/version'

Gem::Specification.new do |spec|
  spec.name          = "rspec_variants"
  spec.version       = RSpec::Variants::VERSION
  spec.authors       = ["Jeff Nyman"]
  spec.email         = ["jeffnyman@gmail.com"]

  spec.summary       = %q{Test and Data Condition DSL for RSpec}
  spec.description   = %q{Test and Data Condition DSL for RSpec}
  spec.homepage      = "https://github.com/jeffnyman/rspec_variants"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rubocop"
  spec.add_development_dependency "pry"

  spec.add_runtime_dependency "proc_to_ast"
  spec.add_runtime_dependency "binding_of_caller"

  spec.post_install_message = %{
(::) (::) (::) (::) (::) (::) (::) (::) (::) (::) (::) (::)
  rspec_variants #{RSpec::Variants::VERSION} has been installed.
(::) (::) (::) (::) (::) (::) (::) (::) (::) (::) (::) (::)
  }
end
