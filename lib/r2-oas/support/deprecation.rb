# frozen_string_literal: true

require_relative 'deprecation/instance_delegator'
require_relative 'deprecation/reporting'
require_relative 'deprecation/behavior'

module R2OAS
  class Deprecation
    include Singleton
    # Be sure to follow the Singleton module
    include InstanceDelegator
    include Behavior
    include Reporting

    # The version number in which the deprecated behavior will be removed, by default.
    attr_accessor :deprecation_horizon

    def initialize(deprecation_horizon = '0.4.2', gem_name = 'r2-oas')
      self.gem_name = gem_name
      self.deprecation_horizon = deprecation_horizon
      self.silenced = false
    end
  end
end
