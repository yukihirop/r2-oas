# frozen_string_literal: true

require 'spec_helper'
require 'yaml'

RSpec.describe 'Jekyll Theme Configuration' do
  let(:docs_root) { File.expand_path('../docs', __dir__) }
  let(:config_file) { File.join(docs_root, '_config.yml') }
  let(:config) { YAML.load_file(config_file) if File.exist?(config_file) }

  describe '_config.yml theme settings' do
    context 'Just-the-Docs configuration' do
      it 'enables Just-the-Docs theme' do
        expect(config['theme']).to eq('just-the-docs')
      end

      it 'sets color scheme' do
        expect(config).to have_key('color_scheme')
        expect(config['color_scheme']).to be_a(String)
      end

      it 'enables search functionality' do
        expect(config['search_enabled']).to be true
      end

      it 'configures navigation sort order' do
        expect(config).to have_key('nav_sort')
        expect(config['nav_sort']).to eq('case_insensitive')
      end

      it 'includes GitHub repository link' do
        expect(config).to have_key('aux_links')
        expect(config['aux_links']).to have_key('GitHub Repository')
      end
    end

    context 'Kramdown Markdown parser' do
      it 'uses Kramdown as Markdown processor' do
        expect(config['markdown']).to eq('kramdown')
      end

      it 'configures Kramdown settings' do
        expect(config).to have_key('kramdown')
        expect(config['kramdown']).to be_a(Hash)
      end

      it 'enables GitHub Flavored Markdown' do
        expect(config['kramdown']['input']).to eq('GFM')
      end

      it 'configures syntax highlighter' do
        expect(config['kramdown']).to have_key('syntax_highlighter')
        expect(config['kramdown']['syntax_highlighter']).to eq('rouge')
      end

      it 'enables line numbers in code blocks' do
        expect(config['kramdown']).to have_key('syntax_highlighter_opts')
        opts = config['kramdown']['syntax_highlighter_opts']
        expect(opts).to have_key('block')
        expect(opts['block']).to have_key('line_numbers')
        expect(opts['block']['line_numbers']).to be true
      end
    end

    context 'Jekyll plugins' do
      it 'includes required plugins' do
        expect(config).to have_key('plugins')
        expect(config['plugins']).to be_an(Array)
      end

      it 'includes jekyll-seo-tag plugin' do
        expect(config['plugins']).to include('jekyll-seo-tag')
      end

      it 'includes jekyll-sitemap plugin' do
        expect(config['plugins']).to include('jekyll-sitemap')
      end
    end

    context 'search configuration' do
      it 'configures search settings' do
        expect(config).to have_key('search')
        expect(config['search']).to be_a(Hash)
      end

      it 'sets heading level for search indexing' do
        expect(config['search']).to have_key('heading_level')
        expect(config['search']['heading_level']).to be_a(Integer)
        expect(config['search']['heading_level']).to be >= 2
      end

      it 'configures search preview settings' do
        expect(config['search']).to have_key('previews')
        expect(config['search']).to have_key('preview_words_before')
        expect(config['search']).to have_key('preview_words_after')
      end
    end
  end

  describe 'custom layouts' do
    let(:layouts_dir) { File.join(docs_root, '_layouts') }

    it 'has _layouts directory' do
      expect(Dir.exist?(layouts_dir)).to be true
    end

    context 'when custom layouts exist' do
      it 'contains valid layout files' do
        if Dir.exist?(layouts_dir)
          layout_files = Dir.glob(File.join(layouts_dir, '*.html'))
          layout_files.each do |layout_file|
            content = File.read(layout_file)
            # Check for basic Jekyll layout structure
            expect(content).to match(/---.*---/m).or include('{{ content }}')
          end
        else
          skip 'No custom layouts directory'
        end
      end
    end
  end

  describe 'custom includes' do
    let(:includes_dir) { File.join(docs_root, '_includes') }
    let(:custom_includes_dir) { File.join(includes_dir, 'custom') }

    it 'has _includes directory' do
      expect(Dir.exist?(includes_dir)).to be true
    end

    it 'has _includes/custom directory' do
      expect(Dir.exist?(custom_includes_dir)).to be true
    end

    context 'info box components' do
      let(:info_box) { File.join(custom_includes_dir, 'info_box.html') }
      let(:warning_box) { File.join(custom_includes_dir, 'warning_box.html') }
      let(:danger_box) { File.join(custom_includes_dir, 'danger_box.html') }

      it 'creates info box include' do
        expect(File.exist?(info_box)).to be true
      end

      it 'creates warning box include' do
        expect(File.exist?(warning_box)).to be true
      end

      it 'creates danger box include' do
        expect(File.exist?(danger_box)).to be true
      end

      it 'info box contains proper structure' do
        if File.exist?(info_box)
          content = File.read(info_box)
          expect(content).to include('info-box')
          expect(content).to include('{{ include.content }}')
        end
      end

      it 'warning box contains proper structure' do
        if File.exist?(warning_box)
          content = File.read(warning_box)
          expect(content).to include('warning-box')
          expect(content).to include('{{ include.content }}')
        end
      end

      it 'danger box contains proper structure' do
        if File.exist?(danger_box)
          content = File.read(danger_box)
          expect(content).to include('danger-box')
          expect(content).to include('{{ include.content }}')
        end
      end
    end
  end

  describe 'custom SCSS' do
    let(:sass_dir) { File.join(docs_root, '_sass') }
    let(:custom_sass_dir) { File.join(sass_dir, 'custom') }
    let(:custom_scss) { File.join(custom_sass_dir, 'custom.scss') }

    it 'has _sass directory' do
      expect(Dir.exist?(sass_dir)).to be true
    end

    it 'has _sass/custom directory' do
      expect(Dir.exist?(custom_sass_dir)).to be true
    end

    it 'creates custom.scss file' do
      expect(File.exist?(custom_scss)).to be true
    end

    context 'when custom.scss exists' do
      it 'contains info box styles' do
        if File.exist?(custom_scss)
          content = File.read(custom_scss)
          expect(content).to include('.info-box')
        end
      end

      it 'contains warning box styles' do
        if File.exist?(custom_scss)
          content = File.read(custom_scss)
          expect(content).to include('.warning-box')
        end
      end

      it 'contains danger box styles' do
        if File.exist?(custom_scss)
          content = File.read(custom_scss)
          expect(content).to include('.danger-box')
        end
      end
    end
  end
end
