class ChangeCoumnToPlan < ActiveRecord::Migration[7.0]
  def change
    change_column :plans, :duration, :integer
  end
end
