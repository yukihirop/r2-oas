#!/usr/bin/env ruby
# frozen_string_literal: true

require 'yaml'
require 'fileutils'

# Navigation structure based on old_docs/_sidebar.md
NAVIGATION_STRUCTURE = {
  'guides' => {
    parent: 'Guides',
    pages: [
      'if_clash.md'
    ]
  },
  'troubleshooting' => {
    parent: 'Troubleshooting',
    pages: [
      'runtime_error.md'
    ]
  },
  'usage' => {
    parent: 'Usage',
    pages: [
      'use_plugins.md',
      'define_tasks.md',
      'use_hook_methods.md',
      'use_hook_to_generate_docs.md',
      'initialize.md',
      'silent_log.md',
      'generate_docs.md',
      'edit_docs.md',
      'view_docs.md',
      'monitor_docs.md',
      'analyze_docs.md',
      'use_schema_namespace.md',
      'use_tag_namespace.md',
      'deploy_docs.md',
      'clean_docs.md'
    ]
  },
  'configuration' => {
    parent: 'Configuration',
    pages: [
      'COC.md',
      'configure.md',
      'CORS.md'
    ]
  },
  'schema' => {
    parent: 'Schema Reference',
    pages: [
      '3.0.0.md'
    ]
  }
}.freeze

# Update front matter in a markdown file
#
# @param file_path [String] Path to the markdown file
# @param parent [String] Parent section title
# @param nav_order [Integer] Navigation order
def update_front_matter(file_path, parent, nav_order)
  content = File.read(file_path)

  # Extract existing front matter
  if content.match(/^---\n(.*?)\n---\n\n/m)
    front_matter_text = Regexp.last_match(1)
    body = content.sub(/^---\n.*?\n---\n\n/m, '')

    # Parse existing front matter
    front_matter = YAML.safe_load(front_matter_text)

    # Add parent and nav_order
    front_matter['parent'] = parent
    front_matter['nav_order'] = nav_order

    # Write updated content
    new_content = "#{front_matter.to_yaml}---\n\n#{body}"
    File.write(file_path, new_content)

    true
  else
    puts "Warning: No front matter found in #{file_path}"
    false
  end
rescue StandardError => e
  puts "Error updating #{file_path}: #{e.message}"
  false
end

# Update navigation for all sections
#
# @param docs_root [String] Root directory of docs
# @return [Hash] Statistics of updates
def update_all_navigation(docs_root)
  stats = {
    total: 0,
    success: 0,
    failed: 0
  }

  NAVIGATION_STRUCTURE.each do |section, config|
    parent = config[:parent]
    pages = config[:pages]

    puts "\nUpdating #{section} section (parent: #{parent}):"
    puts '-' * 50

    pages.each_with_index do |page, index|
      file_path = File.join(docs_root, section, page)

      unless File.exist?(file_path)
        puts "  ⚠ Skipping #{page} (file not found)"
        next
      end

      stats[:total] += 1
      nav_order = index + 1

      if update_front_matter(file_path, parent, nav_order)
        stats[:success] += 1
        puts "  ✓ Updated #{page} (nav_order: #{nav_order})"
      else
        stats[:failed] += 1
        puts "  ✗ Failed to update #{page}"
      end
    end
  end

  stats
end

# Main execution
if __FILE__ == $PROGRAM_NAME
  docs_root = File.expand_path('../docs', __dir__)

  unless Dir.exist?(docs_root)
    puts "Error: docs directory not found at #{docs_root}"
    exit 1
  end

  puts 'R2-OAS Navigation Update Script'
  puts '=' * 50
  puts
  puts "Target: #{docs_root}"
  puts

  if ARGV.include?('--execute')
    results = update_all_navigation(docs_root)

    puts
    puts '=' * 50
    puts 'Navigation Update Complete!'
    puts "Total: #{results[:total]}"
    puts "Success: #{results[:success]}"
    puts "Failed: #{results[:failed]}"

    exit 1 if results[:failed] > 0
  else
    puts 'Navigation structure to be applied:'
    puts

    NAVIGATION_STRUCTURE.each do |section, config|
      puts "#{section}/ (parent: #{config[:parent]})"
      config[:pages].each_with_index do |page, index|
        puts "  #{index + 1}. #{page}"
      end
      puts
    end

    puts 'Run with --execute flag to perform the actual update.'
  end
end
