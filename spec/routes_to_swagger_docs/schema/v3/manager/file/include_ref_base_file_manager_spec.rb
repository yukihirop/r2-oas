require 'spec_helper'

RSpec.describe RoutesToSwaggerDocs::Schema::V3::IncludeRefBaseFileManager do
  let(:path) { '#/components/requestBodies/Api_V1_Task' }
  let(:path_type) { :ref }
  let(:manager) { described_class.new(path, path_type) }

  describe '#descendants_paths' do
    context 'when descendants paths exists' do
      before do
        create_dir('components/schemas')
        create_dir('components/requestBodies')
        create_components_schemas_file('api/v1/task/detail.yml', {
          "components" => {
            "schemas" => {
              "Api_V1_Task_Detail" => {
                "type" => "object",
                "properties" => {
                  "id" => {
                    "type" => "integer",
                    "format" => "int64"
                  }
                }
              }
            }
          }
        }.to_yaml)
        create_components_schemas_file('api/v1/task.yml',{
          "components" => {
            "schemas" => {
              "Api_V1_Task" => {
                "type" => "object",
                "properties" => {
                  "id" => {
                    "type" => "integer",
                    "format" => "int64"
                  },
                  "detail" => {
                    "$ref" => "#/components/schemas/Api_V1_Task_Detail"
                  },
                  "json_schema" => {
                    "$ref" => "#/components/schemas/Api_V1_Task"
                  }
                }
              }
            }
          }
        }.to_yaml)

        create_components_request_bodies_file('api/v1/task.yml',{
          "components" => {
            "requestBodies" => {
              "Api_V1_Task" => {
                "content" => {
                  "application/json" => {
                    "schema" => {
                      "$ref" => "#/components/schemas/Api_V1_Task"
                    }
                  }
                }
              }
            }
          }
        }.to_yaml)
      end

      after do
        delete_swagger_docs
      end

      it do
        expect(manager.descendants_paths).to include(
          "#{components_schemas_path}/api/v1/task.yml",
          "#{components_schemas_path}/api/v1/task/detail.yml"
        )
      end
    end
  end
end 
