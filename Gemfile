# frozen_string_literal: true

# Defaults to puppetcore regardless of PUPPET_FORGE_TOKEN/network state.
# Opt out: bundle config set gemsource.public true
gemsource_default = ENV['GEM_SOURCE'] || 'https://rubygems.org'
gemsource_public_opt_out = Bundler.settings['gemsource.public']
gemsource_puppetcore = if gemsource_public_opt_out
                         gemsource_default
                       else
                         'https://rubygems-puppetcore.puppet.com'
                       end
source gemsource_default

unless ENV['PUPPET_FORGE_TOKEN'] || ENV['BUNDLE_RUBYGEMS___PUPPETCORE__PUPPET__COM'] ||
       Bundler.settings['gemsource.airgapped'] || gemsource_public_opt_out
  Bundler.ui.warn <<~WARNING
    No puppetcore credentials detected.
    On an airgapped install, run `bundle config set gemsource.airgapped true` to suppress this warning.
    To use public gems instead, run `bundle config set gemsource.public true`.
  WARNING
end

def location_for(place_or_constraint, fake_constraint = nil, opts = {})
  git_url_regex  = /\A(?<url>(?:https?|git)[:@][^#]*)(?:#(?<branch>.*))?/
  file_url_regex = %r{\Afile://(?<path>.*)}

  if place_or_constraint && (git_url = place_or_constraint.match(git_url_regex))
    # Git source: ignore :source, keep fake_constraint
    [fake_constraint, { git: git_url[:url], branch: git_url[:branch], require: false }].compact
  elsif place_or_constraint && (file_url = place_or_constraint.match(file_url_regex))
    # File source: ignore :source, keep fake_constraint or default >= 0
    [fake_constraint || '>= 0', { path: File.expand_path(file_url[:path]), require: false }]
  else
    # Plain version constraint: merge opts (including :source if provided)
    [place_or_constraint, { require: false }.merge(opts)]
  end
end

# Works around a bundler multi_json/puppet resolution bug - see pdk-templates/docs/adr/0001.
# Public opt-out pins to the last public puppet release line (8.10.x).
def puppet_floor_version(puppetcore_source)
  return '~> 8.10' if puppetcore_source == 'https://rubygems.org'

  ruby_version = Gem::Version.new(RUBY_VERSION.dup)
  return '~> 9.0' if Gem::Requirement.create('>= 3.4.0').satisfied_by?(ruby_version)
  return '~> 8.17' if Gem::Requirement.create('>= 3.1.0').satisfied_by?(ruby_version)

  nil # puppet 8+ requires ruby >= 3.1; leave older rubies unconstrained
end

gemspec

gem 'base64' if RUBY_VERSION >= '3.4'
gem 'facter', *location_for(ENV.fetch('FACTER_GEM_VERSION', '>= 4'), nil, { source: gemsource_puppetcore })
gem 'puppet', *location_for(ENV.fetch('PUPPET_GEM_VERSION', puppet_floor_version(gemsource_puppetcore)), nil, { source: gemsource_puppetcore })
gem 'syslog', '~> 0.3' if RUBY_VERSION >= '3.4'

group :acceptance do
  gem 'serverspec'
end
