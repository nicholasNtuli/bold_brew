class CreateAddresses < ActiveRecord::Migration[8.0]
  def change
    create_table :addresses do |t|
      t.references :order, null: false, foreign_key: true
      t.string :full_name
      t.string :line1
      t.string :line2
      t.string :city
      t.string :state
      t.string :postal
      t.string :country
      t.string :phone
      t.string :kind

      t.timestamps
    end
  end
end
