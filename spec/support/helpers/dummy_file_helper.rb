# frozen_string_literal: true

module DummyFileHelper
  def create_dummy_components_schemas_file(data = "---\n")
    File.write("#{components_schemas_path}/dummy.yml", data)
  end

  def create_dummy_components_request_bodies_file(data = "---\n")
    File.write("#{components_request_bodies_path}/dummy.yml", data)
  end

  def create_dummy_external_document_file(data = "---\n")
    File.write("#{src_path}/external_docs.yml", data)
  end
end
