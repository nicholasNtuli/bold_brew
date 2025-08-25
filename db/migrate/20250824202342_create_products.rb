class CreateProducts < ActiveRecord::Migration[8.0]
  def change
    create_table :products do |t|
      t.references :category, null: false, foreign_key: true
      t.string :name
      t.string :slug
      t.text :description
      t.integer :price_cents
      t.string :currency
      t.string :sku
      t.integer :stock
      t.boolean :active

      t.timestamps
    end
    add_index :products, :slug, unique: true
  end
end
