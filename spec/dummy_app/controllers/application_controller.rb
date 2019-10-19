# frozen_string_literal: true

class ApplicationController < ActionController::Base
  append_view_path File.dirname(__FILE__)
end
