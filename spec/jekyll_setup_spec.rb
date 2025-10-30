# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Jekyll Project Setup' do
  let(:docs_root) { File.expand_path('../docs', __dir__) }

  describe 'directory structure' do
    it 'creates docs/ directory' do
      expect(Dir.exist?(docs_root)).to be true
    end

    it 'creates _layouts/ directory' do
      expect(Dir.exist?(File.join(docs_root, '_layouts'))).to be true
    end

    it 'creates _includes/ directory' do
      expect(Dir.exist?(File.join(docs_root, '_includes'))).to be true
    end

    it 'creates _sass/ directory' do
      expect(Dir.exist?(File.join(docs_root, '_sass'))).to be true
    end

    it 'creates assets/ directory' do
      expect(Dir.exist?(File.join(docs_root, 'assets'))).to be true
    end
  end

  describe '_config.yml' do
    let(:config_file) { File.join(docs_root, '_config.yml') }
    let(:config_content) { File.read(config_file) if File.exist?(config_file) }

    it 'creates _config.yml file' do
      expect(File.exist?(config_file)).to be true
    end

    context 'when _config.yml exists' do
      it 'contains title' do
        expect(config_content).to include('title:')
        expect(config_content).to match(/title:\s*["']?R2-OAS Documentation["']?/)
      end

      it 'contains description' do
        expect(config_content).to include('description:')
        expect(config_content).to match(/OpenAPI documentation generator for Rails/)
      end

      it 'contains baseurl' do
        expect(config_content).to include('baseurl:')
        expect(config_content).to match(%r{baseurl:\s*["']?/r2-oas["']?})
      end

      it 'contains url' do
        expect(config_content).to include('url:')
        expect(config_content).to match(%r{url:\s*["']?https://yukihirop\.github\.io["']?})
      end

      it 'contains theme configuration' do
        expect(config_content).to include('theme:').or include('remote_theme:')
      end
    end
  end

  describe 'Gemfile' do
    let(:gemfile) { File.join(docs_root, 'Gemfile') }
    let(:gemfile_content) { File.read(gemfile) if File.exist?(gemfile) }

    it 'creates Gemfile' do
      expect(File.exist?(gemfile)).to be true
    end

    context 'when Gemfile exists' do
      it 'includes Jekyll gem' do
        expect(gemfile_content).to match(/gem\s+['"]jekyll['"]/)
      end

      it 'includes Just-the-Docs theme' do
        expect(gemfile_content).to match(/gem\s+['"]just-the-docs['"]/)
      end

      it 'includes jekyll_plugins group' do
        expect(gemfile_content).to include('group :jekyll_plugins')
      end
    end
  end

  describe '.gitignore' do
    let(:gitignore_file) { File.join(docs_root, '.gitignore') }
    let(:gitignore_content) { File.read(gitignore_file) if File.exist?(gitignore_file) }

    it 'creates .gitignore file' do
      expect(File.exist?(gitignore_file)).to be true
    end

    context 'when .gitignore exists' do
      it 'ignores _site/ directory' do
        expect(gitignore_content).to match(%r{_site/?})
      end

      it 'ignores .jekyll-cache/ directory' do
        expect(gitignore_content).to match(%r{\.jekyll-cache/?})
      end

      it 'ignores .sass-cache/ directory' do
        expect(gitignore_content).to match(%r{\.sass-cache/?})
      end
    end
  end
end
