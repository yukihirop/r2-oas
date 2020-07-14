# frozen_string_literal: true

require 'rake'
require_relative 'support/helpers/create_helper'

RSpec.configure do |config|
  include CreateHelper

  config.before(:suite) do
    copy_tasks
    Rails.application.load_tasks
    R2OAS.load_tasks
  end

  config.before(:each) do
    Rake.application.tasks.each(&:reenable)
  end
end
