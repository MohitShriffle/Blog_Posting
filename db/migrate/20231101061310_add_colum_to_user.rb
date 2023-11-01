class AddColumToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :blog_views_count, :integer,:default => 0
  end
end
