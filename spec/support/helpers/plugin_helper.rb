# frozen_string_literal: true

require 'r2-oas/plugin/executor'
require_relative 'hooks_helper'

module PluginHelper
  include HooksHelper

  def reset_plugin
    reset_plugin_repo
    reset_plugin_map
  end

  private

  def reset_plugin_map
    ::R2OAS::Plugin::Executor.plugin_map = {}
  end
end
