# frozen_string_literal: true

require 'spec_helper'
require 'yaml'
require 'fileutils'

RSpec.describe 'Jekyll Content Migration' do
  let(:docs_root) { File.expand_path('../docs', __dir__) }
  let(:old_docs_root) { File.expand_path('../old_docs', __dir__) }

  describe 'migrated directory structure' do
    it 'creates usage directory' do
      expect(Dir.exist?(File.join(docs_root, 'usage'))).to be true
    end

    it 'creates configuration directory' do
      expect(Dir.exist?(File.join(docs_root, 'configuration'))).to be true
    end

    it 'creates schema directory' do
      expect(Dir.exist?(File.join(docs_root, 'schema'))).to be true
    end

    it 'creates guides directory' do
      expect(Dir.exist?(File.join(docs_root, 'guides'))).to be true
    end

    it 'creates troubleshooting directory' do
      expect(Dir.exist?(File.join(docs_root, 'troubleshooting'))).to be true
    end
  end

  describe 'migrated files' do
    context 'index page' do
      let(:index_file) { File.join(docs_root, 'index.md') }

      it 'creates index.md from README.md' do
        expect(File.exist?(index_file)).to be true
      end

      it 'contains front matter' do
        if File.exist?(index_file)
          content = File.read(index_file)
          expect(content).to start_with('---')
          expect(content).to match(/^---.*^---/m)
        end
      end

      it 'has correct permalink' do
        if File.exist?(index_file)
          content = File.read(index_file)
          front_matter = content.match(/^---(.*?)^---/m)[1]
          data = YAML.safe_load(front_matter)
          expect(data['permalink']).to eq('/')
        end
      end
    end

    context 'usage files' do
      let(:usage_dir) { File.join(docs_root, 'usage') }

      it 'migrates usage files' do
        if Dir.exist?(usage_dir)
          files = Dir.glob(File.join(usage_dir, '*.md'))
          expect(files.length).to be > 0
        end
      end

      it 'usage files have front matter' do
        if Dir.exist?(usage_dir)
          files = Dir.glob(File.join(usage_dir, '*.md'))
          files.each do |file|
            content = File.read(file)
            expect(content).to start_with('---')
          end
        end
      end
    end

    context 'configuration files' do
      let(:config_dir) { File.join(docs_root, 'configuration') }

      it 'migrates setting files to configuration' do
        if Dir.exist?(config_dir)
          files = Dir.glob(File.join(config_dir, '*.md'))
          expect(files.length).to be > 0
        end
      end
    end

    context 'schema files' do
      let(:schema_dir) { File.join(docs_root, 'schema') }

      it 'migrates schema files' do
        if Dir.exist?(schema_dir)
          files = Dir.glob(File.join(schema_dir, '*.md'))
          expect(files.length).to be > 0
        end
      end
    end

    context 'guides files' do
      let(:guides_dir) { File.join(docs_root, 'guides') }

      it 'migrates attention files to guides' do
        if Dir.exist?(guides_dir)
          files = Dir.glob(File.join(guides_dir, '*.md'))
          expect(files.length).to be > 0
        end
      end
    end

    context 'troubleshooting files' do
      let(:troubleshooting_dir) { File.join(docs_root, 'troubleshooting') }

      it 'migrates trableshouting files to troubleshooting' do
        if Dir.exist?(troubleshooting_dir)
          files = Dir.glob(File.join(troubleshooting_dir, '*.md'))
          expect(files.length).to be > 0
        end
      end
    end
  end

  describe 'front matter structure' do
    let(:sample_file) { Dir.glob(File.join(docs_root, 'usage', '*.md')).first }

    context 'when migrated files exist' do
      it 'contains layout field' do
        skip 'No migrated files found' unless sample_file && File.exist?(sample_file)

        content = File.read(sample_file)
        front_matter = content.match(/^---(.*?)^---/m)[1]
        data = YAML.safe_load(front_matter)
        expect(data['layout']).to eq('default')
      end

      it 'contains title field' do
        skip 'No migrated files found' unless sample_file && File.exist?(sample_file)

        content = File.read(sample_file)
        front_matter = content.match(/^---(.*?)^---/m)[1]
        data = YAML.safe_load(front_matter)
        expect(data['title']).to be_a(String)
        expect(data['title'].length).to be > 0
      end

      it 'contains permalink field' do
        skip 'No migrated files found' unless sample_file && File.exist?(sample_file)

        content = File.read(sample_file)
        front_matter = content.match(/^---(.*?)^---/m)[1]
        data = YAML.safe_load(front_matter)
        expect(data['permalink']).to be_a(String)
        expect(data['permalink']).to start_with('/')
        expect(data['permalink']).to end_with('/')
      end
    end
  end

  describe 'link conversion' do
    let(:sample_file) { Dir.glob(File.join(docs_root, 'usage', '*.md')).first }

    context 'when migrated files contain links' do
      it 'converts internal links to Jekyll format' do
        if sample_file && File.exist?(sample_file)
          content = File.read(sample_file)
          # Check if there are internal links that have been converted
          if content.include?('](/')
            # Links should use site.baseurl
            internal_links = content.scan(%r{\]\(/[^)]+\)})
            converted_links = content.scan(/\{\{ site\.baseurl \}\}/)

            # If there are internal links, they should be converted
            if internal_links.any?
              expect(converted_links.length).to be > 0
            end
          end
        end
      end
    end
  end

  describe 'content preservation' do
    let(:sample_file) { Dir.glob(File.join(docs_root, 'usage', '*.md')).first }

    it 'preserves original content after front matter' do
      if sample_file && File.exist?(sample_file)
        content = File.read(sample_file)
        # Remove front matter
        content_without_fm = content.sub(/^---.*?^---\n\n/m, '')

        # Should have content remaining
        expect(content_without_fm.length).to be > 0
      end
    end

    it 'preserves code blocks' do
      if sample_file && File.exist?(sample_file)
        content = File.read(sample_file)

        # Check if code blocks are preserved
        if content.include?('```')
          code_blocks = content.scan(/```/)
          # Code blocks should be in pairs
          expect(code_blocks.length % 2).to eq(0)
        end
      end
    end
  end
end
