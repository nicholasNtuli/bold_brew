class Category < ApplicationRecord
    extend FriendlyId
    friendly_id :name, use: :slugged
    has_many :products, dependent: :destroy
    validates :name, presence: true

    def self.ransackable_attributes(auth_object = nil)
        ["name"]
    end
end