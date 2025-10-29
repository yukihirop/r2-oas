# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'fileutils'

RSpec::Core::RakeTask.new(:spec)

task default: :spec

desc 'Generate RBS prototype'
task :rbs_prototype do
  Dir.glob('lib/**/*.rb').each do |file|
    out_path = file.sub(%r{^lib/}, 'sig/').sub(/\.rb$/, '.rbs')
    FileUtils.mkdir_p(File.dirname(out_path))
    system("rbs prototype rb #{file} > #{out_path} 2>&1") || puts("Error: #{file}")
  end
end
