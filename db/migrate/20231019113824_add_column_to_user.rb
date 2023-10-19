class AddColumnToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :blogs, :modifications_count, :integer, default: 0
  end
end
