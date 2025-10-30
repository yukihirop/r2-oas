#!/usr/bin/env ruby
# frozen_string_literal: true

require 'yaml'
require 'fileutils'

# Directory mapping from old_docs to docs
DIRECTORY_MAPPING = {
  'usage' => 'usage',
  'setting' => 'configuration',
  'schema' => 'schema',
  'attention' => 'guides',
  'trableshouting' => 'troubleshooting'
}.freeze

# Excluded files that should not be migrated
EXCLUDED_FILES = ['_sidebar.md'].freeze

# List all markdown files from old_docs directory
#
# @param root_dir [String] The root directory to search
# @return [Array<String>] Array of markdown file paths
def list_markdown_files(root_dir)
  Dir.glob(File.join(root_dir, '**', '*.md')).reject do |file|
    EXCLUDED_FILES.any? { |excluded| file.include?(excluded) }
  end.sort
end

# Generate title from filename
#
# @param filename [String] The filename (e.g., "generate_docs.md")
# @return [String] Title Case title (e.g., "Generate Docs")
def generate_title(filename)
  basename = File.basename(filename, '.md')

  # Special handling for README
  return 'R2-OAS Documentation' if basename == 'README'

  # Convert snake_case to Title Case
  basename.split('_').map(&:capitalize).join(' ')
end

# Generate permalink from directory and filename
#
# @param directory [String] The directory name (e.g., "usage")
# @param filename [String] The filename (e.g., "generate_docs.md")
# @return [String] Permalink (e.g., "/usage/generate-docs/")
def generate_permalink(directory, filename)
  basename = File.basename(filename, '.md')

  # Special handling for README
  return '/' if basename == 'README'

  # Convert to URL-friendly format
  slug = basename.tr('_', '-')

  if directory.empty?
    "/#{slug}/"
  else
    "/#{directory}/#{slug}/"
  end
end

# Add Front Matter to markdown content
#
# @param content [String] The markdown content
# @param title [String] The page title
# @param permalink [String] The page permalink
# @param parent [String, nil] Optional parent page title
# @param nav_order [Integer, nil] Optional navigation order
# @return [String] Content with Front Matter prepended
def add_front_matter(content, title, permalink, parent: nil, nav_order: nil)
  front_matter = {
    'layout' => 'default',
    'title' => title,
    'permalink' => permalink
  }

  front_matter['parent'] = parent if parent
  front_matter['nav_order'] = nav_order if nav_order

  # YAML.to_yaml already adds starting ---, so we only need ending ---
  "#{front_matter.to_yaml}---\n\n#{content}"
end

# Convert Docsify links to Jekyll links
#
# @param content [String] The markdown content
# @return [String] Content with converted links
def convert_links(content)
  # Convert internal links: [Link](/path) -> [Link]({{ site.baseurl }}/path/)
  content.gsub(%r{\[([^\]]+)\]\((/[^)]+)\)}) do |match|
    text = Regexp.last_match(1)
    path = Regexp.last_match(2)

    # Skip external links (http/https)
    next match if path.start_with?('http://', 'https://')

    # Add site.baseurl and ensure trailing slash
    normalized_path = path.end_with?('/') ? path : "#{path}/"
    "[#{text}]({{ site.baseurl }}#{normalized_path})"
  end
end

# Validate content for code blocks and image paths
#
# @param content [String] The markdown content
# @return [Hash] Validation result with :valid, :errors, and :warnings keys
def validate_content(content)
  result = { valid: true, errors: [], warnings: [] }

  # Check for unclosed code blocks
  code_block_count = content.scan(/```/).length
  if code_block_count.odd?
    result[:valid] = false
    result[:errors] << :unclosed_code_block
  end

  # Check for relative image paths
  if content.match?(%r{!\[[^\]]*\]\(\.\./})
    result[:warnings] << :relative_image_path
  end

  result
end

# Display directory mapping information
def display_directory_mapping
  puts 'Directory Mapping:'
  puts '-' * 40
  DIRECTORY_MAPPING.each do |old_dir, new_dir|
    puts "  #{old_dir.ljust(20)} → #{new_dir}"
  end
  puts
end

# Display excluded files information
def display_excluded_files
  puts 'Excluded Files:'
  puts '-' * 40
  EXCLUDED_FILES.each do |file|
    puts "  - #{file}"
  end
  puts
end

# Migrate a single file
#
# @param source_file [String] Source file path
# @param old_docs_root [String] Old docs root directory
# @param docs_root [String] Target docs root directory
# @return [Hash] Migration result
def migrate_file(source_file, old_docs_root, docs_root)
  relative_path = source_file.sub("#{old_docs_root}/", '')

  # Determine target directory
  parts = relative_path.split('/')
  if parts.length == 1
    # Root file (README.md)
    target_dir = docs_root
    target_file = File.join(target_dir, 'index.md')
    directory = ''
  else
    source_dir = parts[0]
    filename = parts[1]

    # Map directory
    target_subdir = DIRECTORY_MAPPING[source_dir] || source_dir
    target_dir = File.join(docs_root, target_subdir)
    target_file = File.join(target_dir, filename)
    directory = target_subdir
  end

  # Read source content
  content = File.read(source_file)

  # Generate metadata
  filename = File.basename(source_file)
  title = generate_title(filename)
  permalink = generate_permalink(directory, filename)

  # Convert links
  converted_content = convert_links(content)

  # Add front matter
  migrated_content = add_front_matter(converted_content, title, permalink)

  # Create target directory
  FileUtils.mkdir_p(target_dir) unless Dir.exist?(target_dir)

  # Write migrated file
  File.write(target_file, migrated_content)

  {
    source: source_file,
    target: target_file,
    success: true
  }
rescue StandardError => e
  {
    source: source_file,
    target: target_file,
    success: false,
    error: e.message
  }
end

# Execute migration for all files
#
# @param old_docs_root [String] Source directory
# @param docs_root [String] Target directory
# @return [Hash] Migration statistics
def execute_migration(old_docs_root, docs_root)
  files = list_markdown_files(old_docs_root)
  results = {
    total: files.length,
    success: 0,
    failed: 0,
    errors: []
  }

  files.each_with_index do |file, index|
    relative_path = file.sub("#{old_docs_root}/", '')
    puts "[#{index + 1}/#{files.length}] Migrating #{relative_path}..."

    result = migrate_file(file, old_docs_root, docs_root)

    if result[:success]
      results[:success] += 1
      puts "  ✓ Success: #{result[:target].sub("#{docs_root}/", '')}"
    else
      results[:failed] += 1
      results[:errors] << result
      puts "  ✗ Failed: #{result[:error]}"
    end
  end

  results
end

# Main execution
if __FILE__ == $PROGRAM_NAME
  puts 'R2-OAS Documentation Migration Script'
  puts '=' * 50
  puts

  old_docs_root = File.expand_path('../old_docs', __dir__)
  docs_root = File.expand_path('../docs', __dir__)

  unless Dir.exist?(old_docs_root)
    puts "Error: old_docs directory not found at #{old_docs_root}"
    exit 1
  end

  puts "Source: #{old_docs_root}"
  puts "Target: #{docs_root}"
  puts

  display_directory_mapping
  display_excluded_files

  files = list_markdown_files(old_docs_root)
  puts "Found #{files.length} markdown files to migrate"
  puts

  # Check if --execute flag is provided
  if ARGV.include?('--execute')
    puts 'Starting migration...'
    puts '=' * 50
    puts

    results = execute_migration(old_docs_root, docs_root)

    puts
    puts '=' * 50
    puts 'Migration Complete!'
    puts "Total: #{results[:total]}"
    puts "Success: #{results[:success]}"
    puts "Failed: #{results[:failed]}"

    if results[:failed] > 0
      puts
      puts 'Errors:'
      results[:errors].each do |error|
        puts "  - #{error[:source]}: #{error[:error]}"
      end
      exit 1
    end
  else
    files.each do |file|
      relative_path = file.sub("#{old_docs_root}/", '')
      puts "  - #{relative_path}"
    end

    puts
    puts 'Migration script is ready to use.'
    puts 'Run with --execute flag to perform the actual migration.'
  end
end
