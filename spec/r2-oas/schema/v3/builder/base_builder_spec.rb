# frozen_string_literal: true

require 'spec_helper'
require 'r2-oas/schema/v3/builder/base_builder'

RSpec.describe R2OAS::Schema::V3::BaseBuilder do
  let(:options) { {} }
  let(:builder) { described_class.new(options) }
  let(:openapi_doc) { double('Schema::V3::OpenapiObject#to_doc') }

  before do
    create_dot_paths
    generate_docs
  end

  after do
    delete_oas_docs
    reset_config
  end

  context 'private methods' do
    describe '#create_glob_schema_paths' do
      context 'when default' do
        before do
          allow(R2OAS).to receive(:use_schema_namespace).and_return(true)
        end

        it do
          expect(builder.send(:create_glob_schema_paths)).to include(
            "#{src_path}/**.yml",
            "#{components_path}/securitySchemes/**/**.yml",
            "#{paths_path}/api/v1/task.yml",
            "#{paths_path}/task.yml",
            "#{components_path}/schemas/api/v1/task.yml",
            "#{components_path}/schemas/task.yml",
            "#{components_path}/requestBodies/api/v1/task.yml",
            "#{components_path}/requestBodies/task.yml"
          )
        end
      end

      context 'when exists paths files' do
        shared_context 'necessary file prepare' do
          before do
            create_components_schemas_file('api/v1/task.yml', yaml_fixture('src/components/schemas/api/v1/task.yml'))
            create_components_schemas_file('api/v1/task/rb.yml', yaml_fixture('src/components/schemas/api/v1/task/rb.yml'))
            create_components_request_bodies_file('api/v1/task/rb.yml', yaml_fixture('src/components/requestBodies/api/v1/task/rb.yml'))
            create_paths_file('api/v1/task.yml', yaml_fixture('src/paths/api/v1/task.yml'))
          end
        end

        context 'when do not specify paths file' do
          include_context 'necessary file prepare'

          it do
            expect(builder.send(:create_glob_schema_paths)).to include(
              "#{src_path}/**.yml",
              "#{paths_path}/api/v1/task.yml",
              "#{components_schemas_path}/api/v1/task.yml",
              "#{components_schemas_path}/api/v1/task/rb.yml",
              "#{components_request_bodies_path}/api/v1/task/rb.yml",
              "#{components_path}/securitySchemes/**/**.yml"
            )
          end
        end

        context 'when specify paths file' do
          let(:options) { { unit_paths_file_path: "#{paths_path}/api/v1/user.yml" } }

          include_context 'necessary file prepare'
          before do
            create_components_schemas_file('/api/v1/user.yml', yaml_fixture('src/components/schemas/api/v1/user.yml'))
            create_paths_file('api/v1/user.yml', yaml_fixture('src/paths/api/v1/user.yml'))
          end

          it do
            expect(builder.send(:create_glob_schema_paths)).to include(
              "#{src_path}/**.yml",
              "#{paths_path}/api/v1/user.yml",
              "#{components_schemas_path}/api/v1/user.yml",
              "#{components_path}/securitySchemes/**/**.yml"
            )
          end
          it do
            expect(builder.send(:create_glob_schema_paths)).not_to include(
              "#{paths_path}/api/v1/task.yml",
              "#{components_schemas_path}/api/v1/task.yml",
              "#{components_schemas_path}/api/v1/task/rb.yml"
            )
          end
        end
      end
    end
  end
end
