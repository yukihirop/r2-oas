# frozen_string_literal: true

require 'r2-oas/plugin/transform/v3/transform'

R2OAS::Plugin::Transform = case ::R2OAS.version
                           when :v3
                             R2OAS::Plugin::V3::Transform
                           else
                             raise NoImplementError, "Do not support version: #{::R2OAS.version}"
  end
