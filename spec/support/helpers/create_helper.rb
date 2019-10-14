require_relative 'path_helper'

module CreateHelper
  include PathHelper
  include FixtureHelper

  def create_dot_paths
    RoutesToSwaggerDocs.paths_config.create_dot_paths
  end

  def delete_swagger_docs
    FileUtils.rm_rf Rails.root.join(root_dir_path)
  end

  def create_dummy_components_schemas_file
    File.write("#{components_schemas_path}/dummy.yml", "---\n")
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
end