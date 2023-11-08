class RemovecolumnfromSubscription < ActiveRecord::Migration[7.0]
  def up 
    remove_column :subscriptions, :auto_renewal, :boolean
    add_column :subscriptions, :auto_renewal, :boolean 
  end
  def down
    remove_column :subscriptions, :auto_renewal, :boolean
  end 
 end
