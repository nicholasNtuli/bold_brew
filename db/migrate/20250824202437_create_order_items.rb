class CreateOrderItems < ActiveRecord::Migration[8.0]
  def change
    create_table :order_items do |t|
      t.references :order, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.string :name
      t.integer :unit_price_cents
      t.integer :quantity
      t.integer :subtotal_cents

      t.timestamps
    end
  end
end
