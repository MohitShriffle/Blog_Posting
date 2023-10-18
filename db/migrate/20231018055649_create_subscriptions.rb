class CreateSubscriptions < ActiveRecord::Migration[7.0]
  def change
    create_table :subscriptions do |t|
      t.datetime :start_date
      t.datetime :end_date
      t.string :duration
      t.decimal :price

      t.timestamps
    end
  end
end
