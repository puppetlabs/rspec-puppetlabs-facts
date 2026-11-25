# frozen_string_literal: true

require 'spec_helper_acceptance'
require 'json'

RSpec.describe 'rspec-puppetlabs-facts' do
  describe command('bundle exec ruby spec/acceptance/scripts/facts_check.rb spec/fixtures/metadata.json') do
    let(:result) { JSON.parse(subject.stdout.lines.last) }
    let(:expected_os) do
      JSON.parse(File.read(File.join(REPO_ROOT, 'spec', 'fixtures', 'metadata.json'), encoding: 'UTF-8'))['operatingsystem_support'].flat_map do |entry|
        entry['operatingsystemrelease'].map { |release| "#{entry['operatingsystem'].downcase}-#{release.split('.').first}-" }
      end
    end

    its(:exit_status) { is_expected.to eq(0) }

    it 'loads the version in lib' do
      expect(result['version']).to eq(File.read(File.join(REPO_ROOT, 'lib', 'rspec-puppetlabs-facts', 'version.rb'))[/STRING = '([^']+)'/, 1])
    end

    it 'returns non-empty facts for each supported OS' do
      expect(result['facts']).not_to be_empty
      expect(result['facts'].values).to all(be > 0)
      expected_os.each do |prefix|
        expect(result['facts'].keys.any? { |key| key.start_with?(prefix) }).to be(true), "no facts for #{prefix}"
      end
    end
  end
end
