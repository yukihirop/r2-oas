require 'spec_helper'
require 'routes_to_swagger_docs/schema/v3/generator/base_generator'

RSpec.describe RoutesToSwaggerDocs::Schema::V3::BaseGenerator do
  let(:options) { {} }
  let(:generator) { described_class.new(options) }
  let(:openapi_doc) { double('Schema::V3::OpenapiObject#to_doc') }

  before do
    create_dot_paths
  end

  after do
    delete_swagger_docs
  end

  context 'private methods' do
    describe '#create_docs' do
      before do
        allow_any_instance_of(RoutesToSwaggerDocs::Schema::V3::OpenapiObject).to receive(:to_doc).and_return(openapi_doc)
      end

      it { expect(generator.send(:create_docs)).to eq openapi_doc }
    end

    describe '#create_glob_schema_paths' do
      context 'when default' do
        it do
          expect(generator.send(:create_glob_schema_paths)).to include(
            "#{src_path}/**.yml",
            "#{paths_path}/**/**.yml",
            "#{components_path}/**/**.yml"
          )
        end
      end

      context 'when exists paths files' do
        shared_context 'necessary file prepare' do
          before do
            create_components_schemas_file('api/v1/task.yml', {
              "components" => {
                "schemas" => {
                  "Api_V1_Task" => {
                    "type" => "object",
                    "properties"=> {
                      "id" => {
                        "type" => "integer",
                        "format" => "int64"
                      }
                    }
                  }
                }
              }
            }.to_yaml)
            create_components_schemas_file('api/v1/task/rb.yml', {
              "components" => {
                "schemas" => {
                  "Api_V1_Task_RB" => {
                    "type" => "object",
                    "properties"=> {
                      "id" => {
                        "type" => "integer",
                        "format" => "int64"
                      }
                    }
                  }
                }
              }
            }.to_yaml)
            create_components_request_bodies_file('api/v1/task/rb.yml', {
              "components" => {
                "requestBodies" => {
                  "Api_V1_Task_RB" => {
                    "content" => {
                      "application/json" => {
                        "schema" => {
                          "$ref" => "#/components/schemas/Api_V1_Task_RB"
                        }
                      }
                    }
                  }
                }
              }
            }.to_yaml)
            create_paths_file('api/v1/task.yml',{
              "paths" => {
                "post" => {
                  "summary" => "api/v1/task summary",
                  "description" => "api/v1/task description",
                  "responses" => {
                    "201" => {
                      "content" => {
                        "application/json" => {
                          "schema" => {
                            "$ref" => "#/components/schemas/Api_V1_Task"
                          }
                        }
                      }
                    }
                  },
                  "requestBody" => {
                    "$ref" => "#/components/requestBodies/Api_V1_Task_RB"
                  }
                }
              }
            }.to_yaml)
          end
        end

        context 'when do not specify paths file' do
          include_context 'necessary file prepare'

          it do
            expect(generator.send(:create_glob_schema_paths)).to include(
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
            create_components_schemas_file('/api/v1/user.yml', {
              "components" => {
                "schemas" => {
                  "Api_V1_User" => {
                    "type" => "object",
                    "properties"=> {
                      "id" => {
                        "type" => "integer",
                        "format" => "int64"
                      }
                    }
                  }
                }
              }
            }.to_yaml)
            create_paths_file('api/v1/user.yml',{
              "paths" => {
                "get" => {
                  "summary" => "api/v1/user summary",
                  "description" => "api/v1/user description",
                  "responses" => {
                    "200" => {
                      "content" => {
                        "application/json" => {
                          "schema" => {
                            "$ref" => "#/components/schemas/Api_V1_User"
                          }
                        }
                      }
                    }
                  }
                }
              }
            }.to_yaml)
          end

          it do
            expect(generator.send(:create_glob_schema_paths)).to include(
              "#{src_path}/**.yml",
              "#{paths_path}/api/v1/user.yml",
              "#{components_schemas_path}/api/v1/user.yml",
              "#{components_path}/securitySchemes/**/**.yml"
            )
          end
          it do
            expect(generator.send(:create_glob_schema_paths)).not_to include(
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
