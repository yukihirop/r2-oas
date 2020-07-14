# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'custom_your_task' do
  let(:task_name) { 'custom:your:task' }
  let(:task) { Rake.application[task_name] }

  subject do
    task.invoke
  end

  it { expect { subject }.to output(/custom your tasks/).to_stdout }
end
