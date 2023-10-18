class ChangeContraintToUser < ActiveRecord::Migration[7.0]
  def change
    change_column :users, :subscription_id, :integer, null: true
  end
end
