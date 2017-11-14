# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'blackbriar/version'

Gem::Specification.new do |spec|
  spec.name          = "blackbriar"
  spec.version       = Blackbriar::VERSION
  spec.authors       = ["Tyrone Wilson"]
  spec.email         = ["tyrone.wilson@blackswan.com"]

  spec.summary       = %q{Gem used for abitrarily mapping JSON Borne data}
  spec.description   = %q{If you need to map JSON to other JSON via some kind of mapping then this gem helps you to do that easily}
  spec.homepage      = "https://github.com/container-streams/blackbriar"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "json_schema", "~> 0.16.2"
  spec.add_dependency "jsonpath", "~> 0.8.2"
  spec.add_dependency "activesupport", "~> 5"

  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", "~> 12"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "sleepers", "~> 0.0.10"

end
