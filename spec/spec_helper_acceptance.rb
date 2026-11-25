# frozen_string_literal: true

require 'open3'
require 'serverspec'
require 'tmpdir'

REPO_ROOT = File.expand_path('..', __dir__)
BUILT_GEM = File.join(Dir.tmpdir, "rspec-puppetlabs-facts-#{Process.pid}.gem")

set :backend, (Gem.win_platform? ? :cmd : :exec)

module Specinfra
  module Backend
    class Cmd
      def execute_script(script)
        if Open3.respond_to?(:capture3)
          stdout, stderr, status = Open3.capture3(script)
          { stdout: stdout, stderr: stderr, status: status }
        else
          stdout = `#{script} 2>&1`
          { stdout: stdout, stderr: nil, status: $? } # rubocop:disable Style/SpecialGlobalVars
        end
      end
    end
  end
end

ENV['LANG'] = 'en_US.UTF-8'
ENV['LANGUAGE'] = 'en_US.UTF-8'
ENV['LC_ALL'] = 'en_US.UTF-8'

# Save the bundle environment from being purged by specinfra. This is restored after every
# example, as specinfra does not reset the environment after a `describe command()` block.
bundler_keys = %w[BUNDLER_EDITOR BUNDLE_BIN_PATH BUNDLE_GEMFILE RUBYOPT GEM_HOME GEM_PATH GEM_CACHE LANG LANGUAGE LC_ALL]
bundler_env = bundler_keys.select { |key| ENV.key?(key) }.to_h { |key| [key, ENV.fetch(key)] }

Specinfra.configuration.env = bundler_env.dup

RSpec.configure do |c|
  c.before(:suite) { Dir.chdir(REPO_ROOT) }

  c.after do |example|
    # Dump stderr into the failure message to help with debugging
    if example.exception && subject.respond_to?(:stderr) && subject.stderr != ''
      example.exception.message << "\nDumping stderr output:\n\n#{subject.stderr}\n"
    end

    bundler_env.each { |key, value| ENV[key] = value }
  end

  c.expect_with(:rspec) do |e|
    e.include_chain_clauses_in_custom_matcher_descriptions = true
  end
end
