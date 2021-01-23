# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sailpoint/version'

Gem::Specification.new do |spec|
  spec.name          = 'sailpoint'
  spec.version       = Sailpoint::VERSION
  spec.authors       = ['Brandon Hicks']
  spec.email         = ['tarellel@gmail.com']

  spec.summary       = %q{A Sailpoint API helper}
  spec.description   = %q{An helper for making API requests to a Sailpoint/IdentityIQ APIendpoint}
  spec.homepage      = 'https://github.com/tarellel/sailpoint'
  spec.license       = 'MIT'
  spec.required_ruby_version = ">= #{Sailpoint::RUBY_VERSION}"

  # spec.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
  spec.metadata = {
    'bug_tracker_uri' => 'https://github.com/tarellel/sailpoint/issues',
    'changelog_uri' => 'https://github.com/tarellel/sailpoint/blob/master/CHANGELOG.md',
    'source_code_uri' => 'https://github.com/tarellel/sailpoint'
  }
  spec.files         = Dir.glob("{bin,lib}/**/*")
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.extra_rdoc_files = %w[README.md LICENSE.txt]
  spec.require_paths = ['lib']

  spec.add_dependency 'httparty', '~> 0.18'
  spec.add_development_dependency 'bundler', '>= 1.17', '< 3.0'
  spec.add_development_dependency 'rake', '~> 13'
  spec.add_development_dependency 'rspec', '~> 3.9'
end
