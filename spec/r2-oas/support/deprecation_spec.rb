# frozen_string_literal: true

require 'spec_helper'
require 'r2-oas/support/deprecation'

RSpec.describe R2OAS::Deprecation do
  describe '#warn (will_remove)' do
    subject do
      described_class.warn(<<-MSG.squish)
        Using a :test_method in configuration is deprecated and
        will be removed in r2-oas (v0.4.2).
      MSG
    end

    it { expect { subject }.to output(/DEPRECATION WARNING: Using a :test_method in configuration is deprecated and will be removed in r2-oas \(v0.4.2\)/).to_stderr }
  end
end
