# frozen_string_literal: true

namespace :custom do
  namespace :your do
    desc 'Custom your task'
    task :task do
      start '[CYT]' do
        puts 'custom your tasks'
      end
    end
  end
end
