#!/bin/bash

# Rspec each All Support Ruby
declare -a report
for version in $@; do
  echo "== Rspec for Ruby Version: ${version} =="
  
  # Change Ruby Version
  echo ${version} > ./.ruby-version && rbenv rehash

  # Rspec
  if [[ $version == "2.3.3" ]];then
    BUNDLE_GEMFILE=./gemfiles/ruby_${version}.gemfile bundle _1.17.3_ exec rspec --format progress && report+=("ruby-${version}: $?")
  else
    BUNDLE_GEMFILE=./gemfiles/ruby_${version}.gemfile bundle exec rspec --format progress && report+=("ruby-${version}: $?")
  fi
  if [ $? -ne 0 ]; then report+=("ruby-${version}: 1 (failed)");fi

  echo "== End for Ruby Version: ${version} =="
done

#  Display report
echo "===== Rspec for All Support Ruby Result ====="
for result in "${report[@]}"; do
  echo $result
done
echo "============================================="
