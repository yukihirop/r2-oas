#!/bin/bash

# Bundle install each All Support Ruby
declare -a report
for version in $@; do
  echo "== Bundle install for Ruby Version: ${version} =="
  
  # Remove gemfile.lock
  lockfile="./gemfiles/ruby_${version}.gemfile.lock"
  if [[ -f $lockfile ]]; then rm $lockfile; fi
  
  # Change Ruby Version
  echo ${version} > ./.ruby-version
  
  # Bundle install with mise shell
  mise shell ruby@${version} -- bash -c "
    BUNDLE_GEMFILE=./gemfiles/ruby_${version}.gemfile bundle install --path vendor/bundle
    exit_code=\$?
    echo \"Bundle install exit code: \$exit_code\"
    exit \$exit_code
  "
  
  if [ $? -eq 0 ]; then 
    report+=("ruby-${version}: 0")
  else 
    report+=("ruby-${version}: 1 (failed)")
  fi

  echo "== End for Ruby Version: ${version} =="
done

#  Display report
echo "===== Bundle install for All Support Ruby Result ====="
for result in "${report[@]}"; do
  echo $result
done
echo "======================================================"
