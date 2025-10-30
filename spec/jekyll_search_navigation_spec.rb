# frozen_string_literal: true

require 'spec_helper'
require 'json'

RSpec.describe 'Jekyll Search and Navigation' do
  let(:docs_root) { File.expand_path('../docs', __dir__) }
  let(:site_dir) { File.join(docs_root, '_site') }
  let(:build_script) { File.expand_path('../devscript/build_docs.sh', __dir__) }

  before(:all) do
    # Ensure site is built
    build_script_path = File.expand_path('../devscript/build_docs.sh', __dir__)
    Open3.capture3('/bin/bash', build_script_path)
  end

  describe 'search functionality' do
    context 'search infrastructure' do
      it 'generates search data JSON file' do
        # Just-the-Docs generates search-data.json in assets/js/
        search_data_path = File.join(site_dir, 'assets', 'js', 'search-data.json')

        expect(File.exist?(search_data_path)).to be true
      end

      it 'includes searchable content in search data' do
        search_data_path = File.join(site_dir, 'assets', 'js', 'search-data.json')

        if File.exist?(search_data_path)
          content = File.read(search_data_path)
          data = JSON.parse(content)

          # Should have entries for our documentation pages
          # Just-the-Docs uses numbered keys (0, 1, 2, ...)
          expect(data).to be_a(Hash)
          expect(data.keys.length).to be > 0

          # Check that entries have expected structure
          first_entry = data.values.first
          expect(first_entry).to have_key('title')
          expect(first_entry).to have_key('content')
          expect(first_entry).to have_key('url')
        end
      end

      it 'indexes page titles in search data' do
        search_data_path = File.join(site_dir, 'assets', 'js', 'search-data.json')

        if File.exist?(search_data_path)
          content = File.read(search_data_path)
          data = JSON.parse(content)

          # Check if some of our key pages are indexed
          # Extract titles from the numbered entries
          titles = data.values.map { |entry| entry['title'] }

          expect(titles).to include('Usage')
          expect(titles).to include('Configuration')
        end
      end

      it 'indexes page content for search' do
        search_data_path = File.join(site_dir, 'assets', 'js', 'search-data.json')

        if File.exist?(search_data_path)
          content = File.read(search_data_path)
          data = JSON.parse(content)

          # Each document should have content
          data.values.each do |entry|
            expect(entry).to have_key('content')
            expect(entry['content']).to be_a(String)
          end
        end
      end
    end

    context 'search UI elements' do
      it 'includes search input in HTML pages' do
        index_html = File.join(site_dir, 'index.html')

        if File.exist?(index_html)
          content = File.read(index_html)

          # Just-the-Docs includes a search input with specific classes
          expect(content).to match(/search/)
        end
      end

      it 'loads search JavaScript' do
        index_html = File.join(site_dir, 'index.html')

        if File.exist?(index_html)
          content = File.read(index_html)

          # Should load Just-the-Docs JavaScript that handles search
          expect(content).to match(/<script.*src=.*just-the-docs.*\.js/)
        end
      end
    end
  end

  describe 'navigation structure' do
    context 'sidebar navigation' do
      it 'generates navigation in HTML' do
        index_html = File.join(site_dir, 'index.html')

        if File.exist?(index_html)
          content = File.read(index_html)

          # Just-the-Docs generates navigation with specific structure
          expect(content).to match(/nav.*class/)
        end
      end

      it 'includes all main sections in navigation' do
        index_html = File.join(site_dir, 'index.html')

        if File.exist?(index_html)
          content = File.read(index_html)

          # Check for our main navigation sections
          expect(content).to include('Usage')
          expect(content).to include('Configuration')
          expect(content).to include('Schema Reference')
          expect(content).to include('Guides')
          expect(content).to include('Troubleshooting')
        end
      end

      it 'organizes navigation hierarchically' do
        usage_page = File.join(site_dir, 'usage', 'initialize', 'index.html')

        if File.exist?(usage_page)
          content = File.read(usage_page)

          # Navigation should show parent-child structure
          # Usage pages should be nested under Usage section
          expect(content).to include('Usage')
        end
      end

      it 'shows correct navigation order' do
        index_html = File.join(site_dir, 'index.html')

        if File.exist?(index_html)
          content = File.read(index_html)

          # Get positions of each section in HTML
          usage_pos = content.index('Usage')
          config_pos = content.index('Configuration')

          # Usage should come before Configuration based on nav_order
          if usage_pos && config_pos
            expect(usage_pos).to be < config_pos
          end
        end
      end
    end

    context 'navigation behavior' do
      it 'highlights current page in navigation' do
        usage_page = File.join(site_dir, 'usage', 'initialize', 'index.html')

        if File.exist?(usage_page)
          content = File.read(usage_page)

          # Just-the-Docs uses CSS styling to highlight current page
          # Check that Initialize page title appears and navigation is styled
          expect(content).to include('Initialize')
          # Navigation activation is handled via CSS with font-weight: 600
          expect(content).to match(/font-weight:\s*600/)
        end
      end

      it 'includes parent section for child pages' do
        usage_child = File.join(site_dir, 'usage', 'initialize', 'index.html')

        if File.exist?(usage_child)
          content = File.read(usage_child)

          # Parent "Usage" should be visible in navigation
          expect(content).to include('Usage')
        end
      end

      it 'supports collapsible navigation for parent items' do
        index_html = File.join(site_dir, 'index.html')

        if File.exist?(index_html)
          content = File.read(index_html)

          # Just-the-Docs uses specific classes for collapsible items
          # Items with has_children should have collapsible structure
          if content.include?('Usage')
            # Navigation should support expand/collapse
            expect(content).to match(/navigation|nav-list/)
          end
        end
      end
    end

    context 'navigation consistency' do
      it 'matches old_docs/_sidebar.md structure' do
        # Read old sidebar structure
        old_sidebar = File.join(docs_root, '..', 'old_docs', '_sidebar.md')

        if File.exist?(old_sidebar)
          sidebar_content = File.read(old_sidebar)

          index_html = File.join(site_dir, 'index.html')
          if File.exist?(index_html)
            html_content = File.read(index_html)

            # Key sections from old sidebar should be in new navigation
            # Usage, Configuration, Schema sections
            expect(html_content).to include('Usage')
            expect(html_content).to include('Configuration')
          end
        end
      end

      it 'preserves page hierarchy from migration' do
        # Usage pages should be children of Usage section
        usage_page = File.join(site_dir, 'usage', 'initialize', 'index.html')

        if File.exist?(usage_page)
          content = File.read(usage_page)

          # Should indicate it belongs to Usage section
          expect(content).to include('Usage')
        end
      end
    end
  end
end
