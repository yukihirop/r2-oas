# frozen_string_literal: true

require 'spec_helper'

RSpec.describe R2OAS::Plugin::Executor do
  let(:plugins) { [] }
  let(:opts) { {} }
  let(:executor) { described_class.new(plugins, opts) }

  describe '#execute_transform_plugins' do
    before do
      allow(described_class).to receive(:plugin_map)
      allow(described_class).to receive(:execute_transform_plugins)
    end

    subject { executor.execute_transform_plugins(:info) }

    context 'when use plugin' do
      let(:opts) { { use_plugin: true } }
      
      context 'when plugins is blank' do
        it do
          subject
          expect(described_class).to have_received(:plugin_map).exactly(0).times
          expect(described_class).to have_received(:execute_transform_plugins).exactly(0).times
        end
      end
      
      context 'when plugins is present' do
        let(:plugins) { [ 'r2oas-plugin-transform-sample' ] }
        
        it do
          subject
          expect(described_class).to have_received(:plugin_map).once
          expect(described_class).to have_received(:execute_transform_plugins).once
        end
      end
    end

    context 'when do not use plugin' do
      it do
        subject
        expect(described_class).to have_received(:plugin_map).exactly(0).times
        expect(described_class).to have_received(:execute_transform_plugins).exactly(0).times
      end
    end
  end

  describe 'execute_transform_plugins' do
    before do
      allow(described_class).to receive(:execute_plugins)
    end

    subject { described_class.execute_transform_plugins({}, :info) }

    it do
      subject
      expect(described_class).to have_received(:execute_plugins).once
    end
  end

  describe 'plugin_map' do
    subject { described_class.plugin_map(plugins) }

    context 'when default' do
      let(:plugins) { ['r2oas-plugin-transform-default'] }

      before do
        class TestDefaultTransform < ::R2OAS::Plugin::Transform
          self.plugin_name = 'r2oas-plugin-transform-default'

          setup do
          end
        end

        R2OAS.configure do |config|
          config.plugins = [
            'r2oas-plugin-transform-default'
          ]
        end
      end

      it { expect(subject).to eq transform: { setup: [{ execute_hook_method: 'execute_setup', plugin_klass: TestDefaultTransform, plugin_name: 'r2oas-plugin-transform-default', plugin_opts: nil }] } }
    end

    context 'When an error occurs' do
      context 'PluginNameError' do
        let(:plugins) { [[nil, {}]] }

        before do
          class SampleTransform < ::R2OAS::Plugin::Transform
          end

          R2OAS.configure do |config|
            config.plugins = [
              [nil, {}]
            ]
          end
        end

        it { expect { subject }.to raise_error(R2OAS::PluginNameError, 'Missing plugin name') }
      end

      context 'NoSupportError' do
        let(:plugins) { [{}, {}] }

        before do
          class TestSample1Transform < ::R2OAS::Plugin::Transform
            self.plugin_name = 'r2oas-plugin-transform-sample'
          end

          R2OAS.configure do |config|
            config.plugins = [{}, {}]
          end
        end

        it { expect { subject }.to raise_error(R2OAS::NoSupportError, "The plugin loading format 'Hash' is incorrect") }
      end

      context 'PluginDuplicationError' do
        let(:plugins) { %w[r2oas-plugin-transform-sample r2oas-plugin-transform-sample] }

        before do
          class TestSample2Transform < ::R2OAS::Plugin::Transform
            self.plugin_name = 'r2oas-plugin-transform-sample'
          end

          R2OAS.configure do |config|
            config.plugins = %w[r2oas-plugin-transform-sample r2oas-plugin-transform-sample]
          end
        end

        it { expect { subject }.to raise_error(R2OAS::PluginDuplicationError, "Plugin: duplicate 'r2oas-plugin-transform-sample'") }
      end

      context 'PluginLoadError' do
        let(:plugins) do [
          'r2oas-plugin-transform-sample-1',
          'r2oas-plugin-transform-sample-2'
          ]
        end

        before do
          class TestSample3Transform < ::R2OAS::Plugin::Transform
            self.plugin_name = 'r2oas-plugin-transform-sample-do-not-used'
          end

          R2OAS.configure do |config|
            config.plugins = [
              'r2oas-plugin-transform-sample-1',
              'r2oas-plugin-transform-sample-2'
            ]
          end
        end

        it { expect { subject }.to raise_error(R2OAS::PluginLoadError, "The 'r2oas-plugin-transform-sample-1, r2oas-plugin-transform-sample-2' plugin doesn't exist or can't be loaded") }
      end
    end
  end
end
