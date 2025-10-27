#!/bin/bash

if [ $# -eq 0 ]; then
  echo "Please specify 'rspec' or 'bundle', 'list'"
  exit 1
fi

# Check if mise is installed
which mise > /dev/null 2>&1 && if [ $? -ne 0 ]; then echo -e 'mise is need\nPlease install mise: https://github.com/mise/mise'; exit 1; fi

declare -a all_support_ruby=(
  '3.2.6'
  '3.3.6'
  '3.4.7'
)

declare -a target_ruby
declare -a versions=${@:2:$#}
if [[ $# > 1 ]]; then
  target_ruby=("${versions[@]}")
else
  target_ruby=("${all_support_ruby[@]}")
fi

command=$1
case $command in
  "bundle")
    source "$(pwd)/devscript/bundle_for_all_support_ruby.sh" "${target_ruby[@]}";;
  "rspec")
    source "$(pwd)/devscript/rspec_for_all_support_ruby.sh" "${target_ruby[@]}";;
  "list")
    echo "===== Display All Support Ruby Version ====="
    for version in "${target_ruby[@]}"; do
      echo "${version}"
    done
    echo "============================================";;
  *)
    echo -n "Do not support command: ${command}\nPlease specify 'bundle' or 'rspec', 'list'"
    exit 1;;
esac

