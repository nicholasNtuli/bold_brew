class Address < ApplicationRecord
  belongs_to :order
  validates :full_name, :line1, :city, :postal, :country, presence: true
end
