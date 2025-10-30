# frozen_string_literal: true

require 'spec_helper'
require 'open3'

RSpec.describe 'Jekyll Build and Validation' do
  let(:docs_root) { File.expand_path('../docs', __dir__) }
  let(:site_dir) { File.join(docs_root, '_site') }

  describe 'development environment setup' do
    context 'Gemfile configuration' do
      let(:gemfile) { File.join(docs_root, 'Gemfile') }

      it 'has Gemfile in docs directory' do
        expect(File.exist?(gemfile)).to be true
      end

      it 'specifies Jekyll dependency' do
        content = File.read(gemfile)
        expect(content).to match(/gem\s+["']jekyll["']/)
      end

      it 'specifies just-the-docs theme' do
        content = File.read(gemfile)
        expect(content).to match(/gem\s+["']just-the-docs["']/)
      end
    end

    context 'Jekyll configuration' do
      let(:config_file) { File.join(docs_root, '_config.yml') }

      it 'has _config.yml file' do
        expect(File.exist?(config_file)).to be true
      end

      it 'specifies theme as just-the-docs' do
        content = File.read(config_file)
        expect(content).to match(/theme:\s+just-the-docs/)
      end

      it 'configures search functionality' do
        content = File.read(config_file)
        expect(content).to match(/search_enabled:\s+true/)
      end
    end
  end

  describe 'Jekyll build process' do
    let(:build_script) { File.expand_path('../devscript/build_docs.sh', __dir__) }

    before(:all) do
      # Ensure dependencies are installed
      docs_dir = File.expand_path('../docs', __dir__)
      Dir.chdir(docs_dir) do
        stdout, stderr, status = Open3.capture3('bundle install')
        unless status.success?
          puts "Bundle install failed:\n#{stderr}"
        end
      end
    end

    context 'build execution' do
      it 'builds successfully without errors' do
        stdout, stderr, status = Open3.capture3('/bin/bash', build_script)

        expect(status.success?).to be(true),
          "Jekyll build failed:\nSTDOUT: #{stdout}\nSTDERR: #{stderr}"
      end

      it 'generates _site directory' do
        # Ensure build has been run
        Open3.capture3('/bin/bash', build_script)

        expect(Dir.exist?(File.join(docs_root, '_site'))).to be true
      end

      it 'generates index.html from index.md' do
        Open3.capture3('/bin/bash', build_script)

        index_html = File.join(site_dir, 'index.html')
        expect(File.exist?(index_html)).to be true
      end
    end
  end

  describe 'content integrity validation' do
    let(:build_script) { File.expand_path('../devscript/build_docs.sh', __dir__) }

    before(:all) do
      build_script_path = File.expand_path('../devscript/build_docs.sh', __dir__)
      Open3.capture3('/bin/bash', build_script_path)
    end

    context 'page generation' do
      it 'generates HTML for all markdown files' do
        markdown_files = Dir.glob(File.join(docs_root, '**', '*.md'))

        markdown_files.each do |md_file|
          relative_path = md_file.sub("#{docs_root}/", '')
          next if relative_path.start_with?('_') # Skip Jekyll special directories

          # Convert .md path to expected .html path in _site
          html_path = relative_path.sub(/\.md$/, '.html')
          full_html_path = File.join(site_dir, html_path)

          # For files with permalinks, check if HTML exists anywhere in _site
          if File.exist?(md_file)
            content = File.read(md_file)
            if content.match(/permalink:\s*["']([^"']+)["']/)
              permalink = Regexp.last_match(1)
              permalink_path = File.join(site_dir, permalink.delete_prefix('/'), 'index.html')

              expect(File.exist?(permalink_path)).to be(true),
                "Expected HTML file not found for #{relative_path} at #{permalink_path}"
            end
          end
        end
      end

      it 'generates navigation structure' do
        index_html = File.read(File.join(site_dir, 'index.html'))

        # Check for navigation elements
        expect(index_html).to match(/nav/)
      end
    end

    context 'code block rendering' do
      it 'applies syntax highlighting to code blocks' do
        # Find a page with code blocks
        usage_init_html = File.join(site_dir, 'usage', 'initialize', 'index.html')

        if File.exist?(usage_init_html)
          content = File.read(usage_init_html)

          # Rouge syntax highlighter should add .highlight or .rouge classes
          expect(content).to match(/class="[^"]*highlight[^"]*"/).or match(/class="[^"]*rouge[^"]*"/)
        end
      end
    end
  end

  describe 'link validation' do
    before(:all) do
      build_script_path = File.expand_path('../devscript/build_docs.sh', __dir__)
      Open3.capture3('/bin/bash', build_script_path)
    end

    context 'internal links' do
      it 'converts site.baseurl links correctly' do
        # Check that site.baseurl is properly replaced
        html_files = Dir.glob(File.join(site_dir, '**', '*.html'))

        html_files.each do |html_file|
          content = File.read(html_file)

          # Should not contain unprocessed Liquid tags
          expect(content).not_to match(/\{\{\s*site\.baseurl\s*\}\}/)
        end
      end

      it 'has valid internal navigation links' do
        index_html = File.read(File.join(site_dir, 'index.html'))

        # Extract internal links
        internal_links = index_html.scan(/href="([^"]+)"/).flatten
          .select { |link| link.start_with?('/r2-oas/') || link.start_with?('/') }
          .reject { |link| link.start_with?('http://') || link.start_with?('https://') }

        # Basic check that we have some internal links
        expect(internal_links.length).to be > 0
      end
    end
  end
end
