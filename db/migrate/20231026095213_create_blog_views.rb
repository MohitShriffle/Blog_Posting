class CreateBlogViews < ActiveRecord::Migration[7.0]
  def change
    create_table :blog_views do |t|
      t.datetime :viewed_at
      t.references :user, null: false, foreign_key: true
      t.references :blog, null: false, foreign_key: true

      t.timestamps
    end
  end
end
