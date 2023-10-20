# frozen_string_literal: true


class CreateSubscriptions < ActiveRecord::Migration[7.0]
  def change
    create_table :subscriptions do |t|
      t.datetime :start_date
      t.datetime :end_date
      t.string :status
      t.boolean :auto_renewal
      t.references :user, null: false, foreign_key: true
      t.references :plan, null: false, foreign_key: true
      t.timestamps
    end
  end
end
