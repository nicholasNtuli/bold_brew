class Order < ApplicationRecord
  include AASM
  belongs_to :user
  has_many :order_items, dependent: :destroy
  has_one :shipping_address, -> { where(kind: "shipping") }, class_name: "Address"
  has_one :billing_address, -> { where(kind: "billing") }, class_name: "Address"

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
end
