# frozen_string_literal: true

require 'spec_helper_acceptance'
require 'fileutils'
require 'rubygems/package'

RSpec.describe 'gem build' do
  after(:all) { FileUtils.rm_f(BUILT_GEM) } # rubocop:disable RSpec/BeforeAfterAll

  describe command("gem build rspec-puppetlabs-facts.gemspec --output \"#{BUILT_GEM}\"") do
    its(:exit_status) { is_expected.to eq(0) }

    it 'includes the renamed files' do
      expect(subject.exit_status).to eq(0)
      expect(Gem::Package.new(BUILT_GEM).contents).to include(
        'lib/rspec-puppetlabs-facts.rb',
        'lib/rspec-puppetlabs-facts/version.rb',
        'ext/puppet_agent_facter_versions.json',
      )
    end
  end
end
