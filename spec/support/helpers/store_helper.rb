# frozen_string_literal: true

require 'r2-oas/store'
require 'r2-oas/schema/v3/object/store'

module StoreHelper
  def reset_store
    ::R2OAS::Store.instance_variable_set(:@instance, nil)
    ::R2OAS::Schema::V3::Store.instance_variable_set(:@instance, nil)
  end
  
  def create_obj_store
    ::R2OAS::Schema::V3::Store.create(:obj)
  end
  
  def set_components_schema_name_list(arr = [])
    obj_store = create_obj_store
    obj_store.components_schema_name_list = arr
  end
  
  def set_components_request_body_name_list(arr = [])
    obj_store = create_obj_store
    obj_store.components_request_body_name_list = arr
  end
end
