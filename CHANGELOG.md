# Changelog

## 6.3.1 (fork start)

This is a fork of [rspec-puppet-facts](https://github.com/voxpupuli/rspec-puppet-facts) 6.3.1.

- Renamed the gem, require path and module to `rspec-puppetlabs-facts` / `RspecPuppetlabsFacts`.
- Depends on Puppet Labs `facter` (>= 4, < 5) and `puppetlabs-facterdb` instead of `openfact` / `facterdb`.
- Rebuilt `ext/puppet_agent_facter_versions.json` for Puppet Labs releases 7.0.0 to 9.1.4.

For earlier history, see [HISTORY.md](HISTORY.md) and the upstream changelog.
