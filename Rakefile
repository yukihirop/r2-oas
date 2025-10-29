# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'fileutils'

RSpec::Core::RakeTask.new(:spec)

task default: :spec

# for EXCLUDE_FILES
desc 'Generate RBS prototype'
task :rbs_prototype do
  FileUtils.mkdir_p('sig')

  files = Dir.glob('lib/**/*.rb')

  files.each do |file|
    rel = file.sub(%r{^lib/}, '')
    out_path = File.join('sig', rel.sub(/\.rb$/, '.rbs'))
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
