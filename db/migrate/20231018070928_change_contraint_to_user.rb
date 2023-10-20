# frozen_string_literal: true

# class ChangeContraintToUser
class ChangeContraintToUser < ActiveRecord::Migration[7.0]
  def up
    change_column :users, :subscription_id, :integer, null: true
  end

  def down
    change_column :users, :subscription_id, :integer, null: false
  end
end
