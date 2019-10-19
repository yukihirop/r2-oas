require_relative 'path_helper'

module CreateHelper
  include PathHelper
  include FixtureHelper

  def create_dot_paths
    RoutesToSwaggerDocs.paths_config.create_dot_paths
  end

  def create_dir(path = '')
    FileUtils.mkdir_p Rails.root.join(src_path, path)
  end

  def delete_swagger_docs
    FileUtils.rm_rf Rails.root.join(root_dir_path)
  end

  def create_components_securitySchemes_file
    FileUtils.mkdir_p(components_securitySchemes_path) unless FileTest.exists?(components_securitySchemes_path)
    File.write("#{components_securitySchemes_path}/my_oauth.yml", "---\n")
  end

  def create_paths_file(file_name = 'dummy.yml', yaml = "---\n")
    dirname = File.dirname("#{paths_path}/#{file_name}")
    FileUtils.mkdir_p(dirname) unless FileTest.exists?(dirname)
    File.write("#{paths_path}/#{file_name}", yaml)
  end

  def create_components_schemas_file(file_name = 'dummy.yml', yaml = "---\n")
    dirname = File.dirname("#{components_schemas_path}/#{file_name}")
    FileUtils.mkdir_p(dirname) unless FileTest.exists?(dirname)
    File.write("#{components_schemas_path}/#{file_name}", yaml)
  end

  def create_components_request_bodies_file(file_name = 'dummy.yml', yaml = "---\n")
    dirname = File.dirname("#{components_request_bodies_path}/#{file_name}")
    FileUtils.mkdir_p(dirname) unless FileTest.exists?(dirname)
    File.write("#{components_request_bodies_path}/#{file_name}", yaml)
  end

  def create_save_doc
    schema_data = YAML.load_file(swagger_file_path(:yml))
    File.write(doc_save_file_path, schema_data.to_yaml)
  end

  def prepare_standard_files
    # Task
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
      # User
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
end
