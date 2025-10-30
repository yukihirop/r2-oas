# frozen_string_literal: true

require 'spec_helper'
require 'yaml'

RSpec.describe 'Jekyll Migration Script' do
  let(:script_path) { File.expand_path('../devscript/migrate_docs.rb', __dir__) }
  let(:old_docs_root) { File.expand_path('../old_docs', __dir__) }
  let(:docs_root) { File.expand_path('../docs', __dir__) }

  describe 'migration script existence' do
    it 'creates migration script file' do
      expect(File.exist?(script_path)).to be true
    end

    it 'migration script is executable Ruby file' do
      if File.exist?(script_path)
        content = File.read(script_path)
        expect(content).to match(/^#!.*ruby/) .or start_with('# frozen_string_literal')
      end
    end
  end

  describe 'directory mapping configuration' do
    before do
      skip 'Migration script not found' unless File.exist?(script_path)
      require script_path
    end

    it 'defines DIRECTORY_MAPPING constant' do
      expect(defined?(DIRECTORY_MAPPING)).to be_truthy
    end

    it 'maps usage to usage' do
      expect(DIRECTORY_MAPPING['usage']).to eq('usage')
    end

    it 'maps setting to configuration' do
      expect(DIRECTORY_MAPPING['setting']).to eq('configuration')
    end

    it 'maps schema to schema' do
      expect(DIRECTORY_MAPPING['schema']).to eq('schema')
    end

    it 'maps attention to guides' do
      expect(DIRECTORY_MAPPING['attention']).to eq('guides')
    end

    it 'maps trableshouting to troubleshooting' do
      expect(DIRECTORY_MAPPING['trableshouting']).to eq('troubleshooting')
    end
  end

  describe 'file listing functionality' do
    before do
      skip 'Migration script not found' unless File.exist?(script_path)
      require script_path
    end

    it 'defines list_markdown_files method' do
      expect(defined?(method(:list_markdown_files))).to be_truthy
    end

    it 'lists all markdown files from old_docs' do
      files = list_markdown_files(old_docs_root)
      expect(files).to be_an(Array)
      expect(files.length).to be > 0
    end

    it 'excludes _sidebar.md from migration' do
      files = list_markdown_files(old_docs_root)
      expect(files.none? { |f| f.include?('_sidebar.md') }).to be true
    end

    it 'includes README.md in migration' do
      files = list_markdown_files(old_docs_root)
      expect(files.any? { |f| f.end_with?('README.md') }).to be true
    end
  end

  describe 'front matter generation' do
    before do
      skip 'Migration script not found' unless File.exist?(script_path)
      require script_path
    end

    it 'defines add_front_matter method' do
      expect(defined?(method(:add_front_matter))).to be_truthy
    end

    it 'generates front matter with required fields' do
      content = "# Test Content\n\nSome text here."
      result = add_front_matter(content, 'Test Title', '/test/')

      expect(result).to match(/^---/)
      expect(result).to include('layout:')
      expect(result).to include('title:')
      expect(result).to include('permalink:')
    end

    it 'includes content after front matter' do
      content = "# Test Content\n\nSome text here."
      result = add_front_matter(content, 'Test Title', '/test/')

      expect(result).to include(content)
    end

    it 'supports optional parent and nav_order' do
      content = "# Test Content"
      result = add_front_matter(content, 'Test Title', '/test/', parent: 'Parent', nav_order: 1)

      expect(result).to include('parent:')
      expect(result).to include('nav_order:')
    end
  end

  describe 'title generation from filename' do
    before do
      skip 'Migration script not found' unless File.exist?(script_path)
      require script_path
    end

    it 'defines generate_title method' do
      expect(defined?(method(:generate_title))).to be_truthy
    end

    it 'converts snake_case to Title Case' do
      expect(generate_title('generate_docs.md')).to eq('Generate Docs')
    end

    it 'handles multiple underscores' do
      expect(generate_title('use_hook_methods.md')).to eq('Use Hook Methods')
    end

    it 'removes .md extension' do
      expect(generate_title('initialize.md')).to eq('Initialize')
    end

    it 'handles README.md specially' do
      title = generate_title('README.md')
      expect(title).to match(/Home|R2-OAS Documentation|Welcome/)
    end
  end

  describe 'permalink generation' do
    before do
      skip 'Migration script not found' unless File.exist?(script_path)
      require script_path
    end

    it 'defines generate_permalink method' do
      expect(defined?(method(:generate_permalink))).to be_truthy
    end

    it 'generates permalink from directory and filename' do
      permalink = generate_permalink('usage', 'generate_docs.md')
      expect(permalink).to match(%r{^/usage/})
      expect(permalink).to end_with('/')
    end

    it 'handles README.md as root' do
      permalink = generate_permalink('', 'README.md')
      expect(permalink).to eq('/')
    end

    it 'converts filename to URL-friendly format' do
      permalink = generate_permalink('usage', 'use_hook_methods.md')
      expect(permalink).to include('use-hook-methods')
    end
  end

  describe 'link conversion' do
    before do
      skip 'Migration script not found' unless File.exist?(script_path)
      require script_path
    end

    it 'defines convert_links method' do
      expect(defined?(method(:convert_links))).to be_truthy
    end

    it 'converts Docsify links to Jekyll links' do
      content = '[Link](/usage/generate_docs)'
      result = convert_links(content)

      expect(result).to include('{{ site.baseurl }}')
    end

    it 'preserves external links' do
      content = '[GitHub](https://github.com/yukihirop/r2-oas)'
      result = convert_links(content)

      expect(result).to eq(content)
    end

    it 'handles multiple links' do
      content = '[Link1](/usage/generate) and [Link2](/setting/configure)'
      result = convert_links(content)

      matches = result.scan(/\{\{ site\.baseurl \}\}/).length
      expect(matches).to eq(2)
    end
  end

  describe 'code block and image validation' do
    before do
      skip 'Migration script not found' unless File.exist?(script_path)
      require script_path
    end

    it 'defines validate_content method' do
      expect(defined?(method(:validate_content))).to be_truthy
    end

    it 'validates code blocks are properly formatted' do
      content = "```ruby\ncode here\n```"
      result = validate_content(content)

      expect(result[:valid]).to be true
    end

    it 'detects unclosed code blocks' do
      content = "```ruby\ncode here"
      result = validate_content(content)

      expect(result[:valid]).to be false
      expect(result[:errors]).to include(:unclosed_code_block)
    end

    it 'validates image paths' do
      content = '![Image](../assets/image.png)'
      result = validate_content(content)

      expect(result[:warnings]).to include(:relative_image_path)
    end
  end
end
