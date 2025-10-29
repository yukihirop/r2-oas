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

    puts "Processing: #{file} -> #{out_path}"
    begin
      result = `rbs prototype rb #{file} 2>&1`
      File.write(out_path, result) unless result.include?('error') || result.include?('Error')
    rescue StandardError => e
      puts "  Skipped (error): #{e.message}"
    end
  end

  puts 'RBS files generated under: sig/'
end
