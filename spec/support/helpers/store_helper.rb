# frozen_string_literal: true

require 'r2-oas/store'
require 'r2-oas/schema/v3/object/store'

module StoreHelper
  def reset_store
    ::R2OAS::Store.instance_variable_set(:@instance, nil)
    ::R2OAS::Schema::V3::Store.instance_variable_set(:@instance, nil)
  end
end
