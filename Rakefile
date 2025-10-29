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

namespace :steep do
  desc 'Generate ignore directives by file and Diagnostic ID'
  task :ignore do
    require 'open3'

    stdout, stderr, status = Open3.capture3('bundle exec steep check')
    output = stdout + stderr

    # ファイルとDiagnostic IDのペアを抽出
    current_file = nil
    pairs = []

    output.each_line do |line|
      if line =~ /^([^\s#].*\.rb):/
        current_file = Regexp.last_match(1).strip
      elsif line =~ /Diagnostic ID: (.+)/
        diagnostic_id = Regexp.last_match(1).strip
        pairs << [current_file, diagnostic_id] if current_file
      end
    end

    pairs.uniq!

    if pairs.empty?
      puts 'No errors found! 🎉'
    else
      puts '# Add to Steepfile:'
      puts 'configure_code_diagnostics do |hash|'
      pairs.group_by(&:last).each do |diag_id, file_pairs|
        file_pairs.each do |file, _|
          puts "  hash['#{diag_id}'] = :information if hash.location.buffer.name.end_with?('#{file}')"
        end
      end
      puts 'end'
    end
  end

  namespace :dig do
    desc 'Generate ignore directives by Diagnostic ID'
    task :ignore do
      require 'open3'

      stdout, stderr, status = Open3.capture3('bundle exec steep check')
      output = stdout + stderr

      # Diagnostic IDを抽出（改行を除去）
      ids = output.scan(/Diagnostic ID: (.+)/).flatten.map(&:strip).uniq.sort

      if ids.empty?
        puts 'No errors found! 🎉'
      else
        ids.each do |id|
          puts "ignore '#{id}'"
        end
      end
    end
  end

  namespace :file do
    desc 'Generate ignore directives by file path'
    task :ignore do
      require 'open3'

      stdout, stderr, status = Open3.capture3('bundle exec steep check')
      output = stdout + stderr

      # エラーが出ているファイルパスを抽出（改行を除去）
      files = output.scan(/^([^\s#].*\.rb):/).flatten.map(&:strip).uniq.sort

      if files.empty?
        puts 'No errors found! 🎉'
      else
        files.each do |file|
          puts "ignore '#{file}'"
        end
      end
    end
  end
end
