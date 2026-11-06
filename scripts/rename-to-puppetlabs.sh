#!/usr/bin/env bash
# Rename rspec-puppet-facts -> rspec-puppetlabs-facts (gem, require path, module).
# Replayable on a fresh upstream tag. Edits code paths only (lib, spec/*.rb, Rakefile,
# gemspec, rubocop files); docs, .github, ext and the gemspec homepage are left alone.
# Never stages, commits or pushes.
#
# Precondition: run on a clean upstream tree where the upstream file names exist and the
# renamed ones do not. After merging a future upstream tag into the renamed branch the
# old-named files reappear beside the renamed ones and `move` stops with an error; that
# merge case needs the manual handling documented under DOC-04 (Phase 4).
set -euo pipefail
cd "$(git rev-parse --show-toplevel)"

move() { # src dst
  [ -e "$1" ] || return 0
  if [ -e "$2" ]; then
    echo "move: both $1 and $2 exist (merge case, see DOC-04)" >&2
    exit 1
  fi
  git mv "$1" "$2"
}

move rspec-puppet-facts.gemspec rspec-puppetlabs-facts.gemspec
move lib/rspec-puppet-facts lib/rspec-puppetlabs-facts
move lib/rspec-puppet-facts.rb lib/rspec-puppetlabs-facts.rb
move spec/rspec_puppet_facts_spec.rb spec/rspec_puppetlabs_facts_spec.rb

subst() {
  local f
  for f in "$@"; do
    sed -i.bak \
      -e '/homepage/!s/rspec-puppet-facts/rspec-puppetlabs-facts/g' \
      -e 's/rspec_puppet_facts/rspec_puppetlabs_facts/g' \
      -e 's/RspecPuppetFacts/RspecPuppetlabsFacts/g' \
      "$f"
    rm -f "$f.bak"
  done
}

files=(Rakefile rspec-puppetlabs-facts.gemspec .rubocop.yml .rubocop_todo.yml)
while IFS= read -r f; do files+=("$f"); done < <(find lib spec -type f -name '*.rb')
subst "${files[@]}"

if [ -e rspec-puppet-facts.gemspec ]; then
  echo 'leftover old names found' >&2
  exit 1
fi

if grep -rnE 'RspecPuppetFacts|rspec-puppet-facts|rspec_puppet_facts' \
     lib spec/*.rb Rakefile rspec-puppetlabs-facts.gemspec .rubocop.yml .rubocop_todo.yml \
     | grep -v '^rspec-puppetlabs-facts\.gemspec:[0-9]*:.*homepage'; then
  echo 'leftover old names found' >&2
  exit 1
fi
echo 'rename complete, no leftovers'
