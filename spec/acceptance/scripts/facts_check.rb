# frozen_string_literal: true

# Run with `bundle exec ruby`: loads the gem as installed by the bundle and prints
# a JSON summary of the facts it returns for the given metadata.json.
require 'json'
require 'rspec'
require 'rspec-puppetlabs-facts'

metadata = JSON.parse(File.read(ARGV.fetch(0), encoding: 'UTF-8'))
facts = Object.new.extend(RspecPuppetlabsFacts).on_supported_os(supported_os: metadata['operatingsystem_support'])

puts JSON.generate( # rubocop:disable RSpec/Output
  'version' => RspecPuppetlabsFacts::Version::STRING,
  'facts' => facts.transform_values(&:size),
)
