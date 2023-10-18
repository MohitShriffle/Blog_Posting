# frozen_string_literal: true

# class CreateUsers
class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :user_name
      t.string :email
      t.string :password_digest
      t.string :opt
      t.datetime :otp_sent_at
      t.string :type
      t.references :subscription, null: false, foreign_key: true

      t.timestamps
    end
  end
end
