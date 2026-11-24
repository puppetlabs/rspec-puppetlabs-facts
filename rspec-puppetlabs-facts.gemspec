# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path('lib', __dir__)
require 'rspec-puppetlabs-facts/version'

Gem::Specification.new do |s|
  s.name        = 'rspec-puppetlabs-facts'
  s.version     = RspecPuppetlabsFacts::Version::STRING
  s.authors     = ['Puppet Labs', 'Vox Pupuli']
  s.homepage    = 'https://github.com/puppetlabs/rspec-puppetlabs-facts'
  s.summary     = 'Standard facts fixtures for Puppet, using Puppet Labs facter'
  s.description = 'Contains facts from many Facter 4.x versions on many operating systems for rspec-puppet tests, ' \
                  'sourced from puppetlabs-facterdb. Forked from the Vox Pupuli gem at version 6.3.1.'
  s.licenses    = 'Apache-2.0'

  s.required_ruby_version = '>= 3.2.0'

  s.files       = `git ls-files`.split("\n")
  s.executables = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }

  s.add_development_dependency 'mime-types', '~> 3.5', '>= 3.5.2'
  s.add_development_dependency 'rake', '~> 13.1'
  s.add_development_dependency 'rspec', '~> 3.12'
  s.add_development_dependency 'yard', '~> 0.9.34'

  s.add_development_dependency 'voxpupuli-rubocop', '~> 5.2.0'

  s.add_dependency 'deep_merge', '~> 1.2'

  s.add_dependency 'facter', '>= 4', '< 5'
  s.add_dependency 'puppetlabs-facterdb', '~> 0.1'
end
