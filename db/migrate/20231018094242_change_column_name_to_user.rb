class ChangeColumnNameToUser < ActiveRecord::Migration[7.0]
  def change
    rename_column :users, :opt, :otp
  end
end