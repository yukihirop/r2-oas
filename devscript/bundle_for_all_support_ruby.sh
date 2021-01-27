#!/bin/bash

# Bundle install each All Support Ruby
declare -a report
for version in $@; do
  echo "== Bundle install for Ruby Version: ${version} =="
  
  # Remove gemfile.lock
  lockfile="./gemfiles/ruby_${version}.gemfile.lock"
  if [[ -f $lockfile ]]; then rm $lockfile; fi
  
  # Change Ruby Version
  echo ${version} > ./.ruby-version && rbenv rehash
  
  # Bundle install
  BUNDLE_GEMFILE=./gemfiles/ruby_${version}.gemfile bundle install --path vendor/bundle && report+=("ruby-${version}: $?") 
  if [ $? -ne 0 ]; then report+=("ruby-${version}: 1 (failed)");fi

  echo "== End for Ruby Version: ${version} =="
done

#  Display report
echo "===== Bundle install for All Support Ruby Result ====="
for result in "${report[@]}"; do
  echo $result
done
echo "======================================================"
