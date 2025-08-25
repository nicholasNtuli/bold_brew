class Cart < ApplicationRecord
  belongs_to :user, optional: true
  has_many :line_items, dependent: :destroy

  def add(product, qty = 1)
    item = line_items.find_or_initialize_by(product: product)
    item.unit_price_cents ||= product.price_cents
    item.quantity = item.quantity.to_i + qty
    item.save
  end

  def total_cents
    line_items.sum("quantity * unit_price_cents")
  end
end