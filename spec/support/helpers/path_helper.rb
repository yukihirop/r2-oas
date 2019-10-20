# frozen_string_literal: true

module PathHelper
  def root_dir_path
    R2OAS.root_dir_path
  end

  def schema_save_dir_name
    R2OAS.schema_save_dir_name
  end

  def doc_save_file_name
    R2OAS.doc_save_file_name
  end

  def deploy_dir_path
    R2OAS.deploy_dir_path
  end

  def dot_paths_path
    "#{root_dir_path}/.paths"
  end

  def doc_save_file_path
    "#{root_dir_path}/#{doc_save_file_name}"
  end

  def src_path
    "#{root_dir_path}/#{schema_save_dir_name}"
  end

  def components_path
    "#{root_dir_path}/#{schema_save_dir_name}/components"
  end

  def components_schemas_path
    "#{root_dir_path}/#{schema_save_dir_name}/components/schemas"
  end

  def components_request_bodies_path
    "#{root_dir_path}/#{schema_save_dir_name}/components/requestBodies"
  end

  def components_securitySchemes_path
    "#{root_dir_path}/#{schema_save_dir_name}/components/securitySchemes"
  end

  def paths_path
    "#{root_dir_path}/#{schema_save_dir_name}/paths"
  end

  def external_docs_path
    "#{root_dir_path}/#{schema_save_dir_name}/external_docs.yml"
  end

  def info_path
    "#{root_dir_path}/#{schema_save_dir_name}/info.yml"
  end

  def openapi_path
    "#{root_dir_path}/#{schema_save_dir_name}/openapi.yml"
  end

  def servers_path
    "#{root_dir_path}/#{schema_save_dir_name}/servers.yml"
  end

  def tags_path
    "#{root_dir_path}/#{schema_save_dir_name}/tags.yml"
  end
end
