# frozen_string_literal: true

require 'bundler/gem_tasks'

PUPPET_VERSIONS_PATH = File.join(__dir__, 'ext', 'puppet_agent_facter_versions.json')

LEFTOVER_PATTERN = /RspecPuppetFacts|rspec-puppet-facts|voxpupuli|openfact/i
LEFTOVER_ALLOWED_TOKENS = %r{voxpupuli-rubocop|voxpupuli/rubocop}i
LEFTOVER_ALLOWED_FILES = %w[
  README.md
  HISTORY.md
  CHANGELOG.md
  LICENSE
  scripts/rename-to-puppetlabs.sh
  Rakefile
].freeze

require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec) do |t|
  t.exclude_pattern = 'spec/spec_helper_acceptance.rb,spec/acceptance/**'
end

namespace :acceptance do
  desc 'Run acceptance tests against the built gem'
  RSpec::Core::RakeTask.new(:local) do |t|
    t.pattern = 'spec/acceptance/**/*_spec.rb'
  end
end

begin
  require 'yard'
  YARD::Rake::YardocTask.new
rescue LoadError
  # yard is optional
end

desc 'Produce Commit history since last tag'
task :dump_commit do
  last_tag = `git describe --tags $(git rev-list --tags --max-count=1)`.chomp
  puts "############ Commits since #{last_tag} ######"
  puts `git log --pretty=format:"- %s" #{last_tag}..HEAD`
end

namespace :puppet_versions do
  desc 'updates the vendored list of puppet versions & components'
  task :update do
    warn 'The rake task is disabled since the 6.0.0 Release. Please see the README.md'
    exit 1
  end

  desc 'runs all tests and verifies vendored component list'
  task :test do
    warn 'The rake task is disabled since the 6.0.0 Release. Please see the README.md'
    exit 1
  end
end

def tracked_files
  files = `git ls-files -z`.split("\0")
  abort 'check_leftovers: git ls-files returned no files' unless Process.last_status.success? && !files.empty?
  files
end

def leftover_hits(path)
  File.foreach(path).with_index(1).filter_map do |line, number|
    text = line.scrub.gsub(LEFTOVER_ALLOWED_TOKENS, '')
    "#{path}:#{number}: #{line.scrub.strip}" if text.match?(LEFTOVER_PATTERN)
  end
end

desc 'Fail on leftover upstream names outside the allowlist'
task :check_leftovers do
  files = tracked_files.reject { |path| LEFTOVER_ALLOWED_FILES.include?(path) }
  hits = files.select { |path| File.file?(path) }.flat_map { |path| leftover_hits(path) }
  abort "Leftover upstream names found (allowlist in Rakefile):\n#{hits.join("\n")}" unless hits.empty?

  puts 'check_leftovers: OK'
end

begin
  require 'voxpupuli/rubocop/rake'
rescue LoadError
  # the voxpupuli-rubocop gem is optional
end

desc 'Run rspec, rubocop and the leftover-name check'
task default: %i[spec rubocop check_leftovers]
