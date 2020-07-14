# frozen_string_literal: true

require 'r2-oas/store'

module StoreHelper
  def reset_store
    ::R2OAS::Store.instance_variable_set(:@instance, nil)
  end
end
