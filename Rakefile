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
  namespace :ignore do
    desc 'Generate ignore directives by Diagnostic ID'
    task :dig do
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

    desc 'Generate ignore directives by file path'
    task :file do
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

    # desc 'Automatically add # steep:ignore with diagnostic ID (before line)'
    task :auto do
      require 'open3'

      puts 'Analyzing steep check errors...'
      stdout, stderr, status = Open3.capture3('bundle exec steep check')
      output = stdout + stderr

      # ファイル、行番号、Diagnostic IDを抽出
      errors = []
      current_file = nil
      current_line = nil

      output.each_line do |line|
        if line =~ /^([^\s#].*\.rb):(\d+):(\d+):/
          current_file = Regexp.last_match(1).strip
          current_line = Regexp.last_match(2).to_i
        elsif line =~ /Diagnostic ID: (.+)/ && current_file && current_line
          diagnostic_id = Regexp.last_match(1).strip
          errors << {
            file: current_file,
            line: current_line,
            diagnostic_id: diagnostic_id
          }
        end
      end

      if errors.empty?
        puts 'No errors found! 🎉'
        exit 0
      end

      # ファイルごとにグループ化
      errors_by_file = errors.group_by { |e| e[:file] }

      modified_files = []

      errors_by_file.each do |file, file_errors|
        unless File.exist?(file)
          puts "⚠️  Skipping #{file} (file not found)"
          next
        end

        lines = File.readlines(file)

        # 行番号ごとにグループ化
        errors_by_line = file_errors.group_by { |e| e[:line] }

        # 逆順で処理（行番号がずれないように）
        errors_by_line.keys.sort.reverse.each do |line_num|
          next if line_num > lines.size || line_num < 1

          target_line = lines[line_num - 1]
          diagnostic_ids = errors_by_line[line_num].map { |e| e[:diagnostic_id] }.uniq

          # 既に steep:ignore がある行またはその前の行にある場合はスキップ
          prev_line = line_num > 1 ? lines[line_num - 2] : ''
          next if target_line =~ /steep:ignore/ || prev_line =~ /steep:ignore/

          # インデントを取得
          indent = target_line[/^\s*/]

          # コメント行を作成
          comment_line = if diagnostic_ids.size == 1
                           "#{indent}# steep:ignore #{diagnostic_ids.first}\n"
                         else
                           "#{indent}# steep:ignore #{diagnostic_ids.join(', ')}\n"
                         end

          # コメント行を挿入
          lines.insert(line_num - 1, comment_line)
        end

        # ファイルに書き戻す
        File.write(file, lines.join)
        modified_files << file
        puts "✅ Modified: #{file} (#{errors_by_line.keys.size} lines)"
      end

      puts "\n" + ('=' * 60)
      puts 'Summary:'
      puts "  Modified files: #{modified_files.size}"
      puts "  Total errors ignored: #{errors.size}"
      puts '=' * 60
    end

    desc 'Preview steep:ignore comments (dry run)'
    task :preview do
      require 'open3'

      puts 'Analyzing steep check errors...'
      stdout, stderr, status = Open3.capture3('bundle exec steep check')
      output = stdout + stderr

      # ファイル、行番号、Diagnostic IDを抽出
      errors = []
      current_file = nil
      current_line = nil

      output.each_line do |line|
        if line =~ /^([^\s#].*\.rb):(\d+):(\d+):/
          current_file = Regexp.last_match(1).strip
          current_line = Regexp.last_match(2).to_i
        elsif line =~ /Diagnostic ID: (.+)/ && current_file && current_line
          diagnostic_id = Regexp.last_match(1).strip
          errors << {
            file: current_file,
            line: current_line,
            diagnostic_id: diagnostic_id
          }
        end
      end

      if errors.empty?
        puts 'No errors found! 🎉'
        exit 0
      end

      # ファイルごとにグループ化
      errors_by_file = errors.group_by { |e| e[:file] }

      errors_by_file.each do |file, file_errors|
        unless File.exist?(file)
          puts "⚠️  Skipping #{file} (file not found)"
          next
        end

        puts "\n📄 #{file}"
        lines = File.readlines(file)

        # 行番号ごとにグループ化
        errors_by_line = file_errors.group_by { |e| e[:line] }

        errors_by_line.keys.sort.each do |line_num|
          next if line_num > lines.size || line_num < 1

          target_line = lines[line_num - 1]
          diagnostic_ids = errors_by_line[line_num].map { |e| e[:diagnostic_id] }.uniq

          # 既に steep:ignore がある場合
          prev_line = line_num > 1 ? lines[line_num - 2] : ''
          if target_line =~ /steep:ignore/ || prev_line =~ /steep:ignore/
            puts "  Line #{line_num}: [ALREADY IGNORED]"
            puts "    #{prev_line.strip}" if prev_line =~ /steep:ignore/
            puts "    #{target_line.strip}"
          else
            indent = target_line[/^\s*/]

            if diagnostic_ids.size == 1
              puts "  Line #{line_num}: WILL ADD:"
              puts "    #{indent}# steep:ignore #{diagnostic_ids.first}"
              puts "    #{target_line.strip}"
            else
              puts "  Line #{line_num}: WILL ADD:"
              puts "    #{indent}# steep:ignore #{diagnostic_ids.join(', ')}"
              puts "    #{target_line.strip}"
            end
          end
        end
      end

      puts "\n" + ('=' * 60)
      puts "Run 'bundle exec rake steep:ignore:auto' to apply changes"
      puts '=' * 60
    end
  end
end
