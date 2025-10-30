# frozen_string_literal: true

require 'spec_helper'
require 'yaml'

RSpec.describe 'Jekyll Navigation Structure' do
  let(:docs_root) { File.expand_path('../docs', __dir__) }

  describe 'section index pages' do
    context 'Usage section' do
      let(:usage_index) { File.join(docs_root, 'usage', 'index.md') }

      it 'creates usage index page' do
        expect(File.exist?(usage_index)).to be true
      end

      it 'has correct front matter' do
        if File.exist?(usage_index)
          content = File.read(usage_index)
          front_matter = content.match(/^---(.*?)^---/m)[1]
          data = YAML.safe_load(front_matter)

          expect(data['title']).to eq('Usage')
          expect(data['has_children']).to be true
          expect(data['nav_order']).to be_a(Integer)
        end
      end
    end

    context 'Configuration section' do
      let(:config_index) { File.join(docs_root, 'configuration', 'index.md') }

      it 'creates configuration index page' do
        expect(File.exist?(config_index)).to be true
      end

      it 'has correct front matter' do
        if File.exist?(config_index)
          content = File.read(config_index)
          front_matter = content.match(/^---(.*?)^---/m)[1]
          data = YAML.safe_load(front_matter)

          expect(data['title']).to eq('Configuration')
          expect(data['has_children']).to be true
        end
      end
    end

    context 'Schema section' do
      let(:schema_index) { File.join(docs_root, 'schema', 'index.md') }

      it 'creates schema index page' do
        expect(File.exist?(schema_index)).to be true
      end

      it 'has correct front matter' do
        if File.exist?(schema_index)
          content = File.read(schema_index)
          front_matter = content.match(/^---(.*?)^---/m)[1]
          data = YAML.safe_load(front_matter)

          expect(data['title']).to eq('Schema Reference')
          expect(data['has_children']).to be true
        end
      end
    end

    context 'Guides section' do
      let(:guides_index) { File.join(docs_root, 'guides', 'index.md') }

      it 'creates guides index page' do
        expect(File.exist?(guides_index)).to be true
      end

      it 'has correct front matter' do
        if File.exist?(guides_index)
          content = File.read(guides_index)
          front_matter = content.match(/^---(.*?)^---/m)[1]
          data = YAML.safe_load(front_matter)

          expect(data['title']).to eq('Guides')
          expect(data['has_children']).to be true
        end
      end
    end

    context 'Troubleshooting section' do
      let(:troubleshooting_index) { File.join(docs_root, 'troubleshooting', 'index.md') }

      it 'creates troubleshooting index page' do
        expect(File.exist?(troubleshooting_index)).to be true
      end

      it 'has correct front matter' do
        if File.exist?(troubleshooting_index)
          content = File.read(troubleshooting_index)
          front_matter = content.match(/^---(.*?)^---/m)[1]
          data = YAML.safe_load(front_matter)

          expect(data['title']).to eq('Troubleshooting')
          expect(data['has_children']).to be true
        end
      end
    end
  end

  describe 'navigation parent-child relationships' do
    let(:sample_usage_file) { File.join(docs_root, 'usage', 'initialize.md') }

    it 'usage pages have parent set to Usage' do
      if File.exist?(sample_usage_file)
        content = File.read(sample_usage_file)
        front_matter = content.match(/^---(.*?)^---/m)[1]
        data = YAML.safe_load(front_matter)

        expect(data['parent']).to eq('Usage')
      end
    end

    it 'usage pages have nav_order' do
      if File.exist?(sample_usage_file)
        content = File.read(sample_usage_file)
        front_matter = content.match(/^---(.*?)^---/m)[1]
        data = YAML.safe_load(front_matter)

        expect(data['nav_order']).to be_a(Integer)
      end
    end
  end

  describe 'navigation ordering' do
    context 'section-level ordering' do
      let(:index_file) { File.join(docs_root, 'index.md') }
      let(:usage_index) { File.join(docs_root, 'usage', 'index.md') }
      let(:config_index) { File.join(docs_root, 'configuration', 'index.md') }

      it 'sections have sequential nav_order' do
        if File.exist?(usage_index) && File.exist?(config_index)
          usage_content = File.read(usage_index)
          usage_fm = usage_content.match(/^---(.*?)^---/m)[1]
          usage_data = YAML.safe_load(usage_fm)

          config_content = File.read(config_index)
          config_fm = config_content.match(/^---(.*?)^---/m)[1]
          config_data = YAML.safe_load(config_fm)

          expect(usage_data['nav_order']).to be < config_data['nav_order']
        end
      end
    end

    context 'page-level ordering within Usage' do
      let(:initialize_file) { File.join(docs_root, 'usage', 'initialize.md') }
      let(:generate_file) { File.join(docs_root, 'usage', 'generate_docs.md') }

      it 'usage pages have appropriate ordering' do
        if File.exist?(initialize_file) && File.exist?(generate_file)
          init_content = File.read(initialize_file)
          init_fm = init_content.match(/^---(.*?)^---/m)[1]
          init_data = YAML.safe_load(init_fm)

          gen_content = File.read(generate_file)
          gen_fm = gen_content.match(/^---(.*?)^---/m)[1]
          gen_data = YAML.safe_load(gen_fm)

          # Initialize should come before Generate
          expect(init_data['nav_order']).to be < gen_data['nav_order']
        end
      end
    end
  end
end
