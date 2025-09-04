class Order < ApplicationRecord
  include AASM
  belongs_to :user
  has_many :order_items, dependent: :destroy
  has_one :shipping_address, -> { where(kind: "shipping") }, class_name: "Address"
  has_one :billing_address, -> { where(kind: "billing") }, class_name: "Address"

  validates :total_cents, presence: true, numericality: { greater_than: 0 }
  validates :currency, presence: true

  # Add scope for different order states
  scope :pending, -> { where(status: 'pending') }
  scope :paid, -> { where(status: 'paid') }
  scope :shipped, -> { where(status: 'shipped') }
  scope :canceled, -> { where(status: 'canceled') }

  aasm column: "status" do
    state :pending, initial: true
    state :paid
    state :shipped
    state :canceled

    event :pay do
      transitions from: :pending, to: :paid
    end

    event :ship do
      transitions from: :paid, to: :shipped
    end

    event :cancel do
      transitions from: [:pending, :paid], to: :canceled
    end
  end

  # Helper methods for display
  def can_be_canceled?
    pending? || paid?
  end

  def status_color
    case status
    when 'pending'
      'text-yellow-600 bg-yellow-100'
    when 'paid'
      'text-blue-600 bg-blue-100'
    when 'shipped'
      'text-green-600 bg-green-100'
    when 'canceled'
      'text-red-600 bg-red-100'
    else
      'text-gray-600 bg-gray-100'
    end
  end

  def formatted_status
    status.humanize
  end

  def total_in_currency
    total_cents / 100.0
  end
end