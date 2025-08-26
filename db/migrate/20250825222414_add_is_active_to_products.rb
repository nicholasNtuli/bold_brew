class AddIsActiveToProducts < ActiveRecord::Migration[8.0]
  def change
    add_column :products, :is_active, :boolean
  end
end
