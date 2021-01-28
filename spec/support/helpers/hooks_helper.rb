# frozen_string_literal: true

require 'r2-oas/hooks/hook'

module HooksHelper
  def reset_plugin_repo
    ::R2OAS::Hooks::Hook.repository[:plugin] = {} if ::R2OAS::Hooks::Hook.repository.is_a? Hash
  end
end
