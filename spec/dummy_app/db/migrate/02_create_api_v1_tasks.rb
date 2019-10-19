# frozen_string_literal: true

class CreateApiV1Tasks < ActiveRecord::Migration[5.0]
  def change
    create_table :api_v1_tasks do |t|
      t.string :status
      t.string :content

      t.timestamps
    end
  end
end
