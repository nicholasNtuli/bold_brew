class Product < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged
  belongs_to :category
  has_many_attached :images
  scope :active, -> { where(active: true) }
  monetize :price_cents, as: :price, with_model_currency: :currency, allow_nil: true rescue nil
  validates :name, :price_cents, :currency, presence: true

  def self.ransackable_attributes(auth_object = nil)
    ["name", "price_cents", "created_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["category"]
  end
end