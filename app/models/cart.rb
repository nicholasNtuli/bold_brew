class Cart < ApplicationRecord
  belongs_to :user, optional: true
  has_many :line_items, dependent: :destroy

  scope :guest_carts, -> { where(user_id: nil) }
  scope :user_carts, -> { where.not(user_id: nil) }

  def add(product, qty = 1)
    item = line_items.find_or_initialize_by(product: product)
    item.unit_price_cents ||= product.price_cents
    item.quantity = item.quantity.to_i + qty.to_i
    item.save
  end

  def total_cents
    line_items.sum("quantity * unit_price_cents")
  end

  def total_items
    line_items.sum(:quantity)
  end

  def guest_cart?
    user_id.nil?
  end

  def user_cart?
    user_id.present?
  end
  
  def self.cleanup_old_guest_carts(days_old = 7)
    guest_carts.where('created_at < ?', days_old.days.ago).destroy_all
  end
end