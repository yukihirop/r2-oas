# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'fileutils'

RSpec::Core::RakeTask.new(:spec)

task default: :spec

# for EXCLUDE_FILES
desc "Generate RBS prototype"
task :rbs_prototype do
    FileUtils.mkdir_p('sig')
    
    files = Dir.glob("lib/**/*.rb")
    
    File.open('sig/r2-oas.rbs', 'w') do |output|
      files.each do |file|
        puts "Processing: #{file}"
        begin
          result = `rbs prototype rb #{file} 2>&1`
          unless result.include?('error') || result.include?('Error')
            output.puts result
            output.puts ""
          end
        rescue => e
          puts "  Skipped (error): #{e.message}"
        end
      end
    end
    
    puts "RBS file generated: sig/r2-oas.rbs"
  end