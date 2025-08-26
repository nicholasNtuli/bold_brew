class RemoveIsActiveFromProducts < ActiveRecord::Migration[7.1]
  def change
    add_column :products, :active, :boolean unless column_exists?(:products, :active)
    
    Product.where.not(is_active: nil).each do |product|
      product.update_column(:active, product.is_active)
    end
    
    # Remove the column
    remove_column :products, :is_active, :boolean
  end
end