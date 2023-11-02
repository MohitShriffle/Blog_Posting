class ChangeCoumnToPlan < ActiveRecord::Migration[7.0]
  def up
    change_column :plans, :duration, :integer
    change_column :subscriptions, :status,:integer
  end
  def down
    change_column :plans, :duration, :string
    change_column :subscriptions, :status, :string
  end
end
