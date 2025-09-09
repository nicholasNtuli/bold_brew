class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  has_many :orders

  before_destroy :check_for_orders

  private
  def check_for_orders
    if orders.exists?
      errors.add(:base, "Cannot delete account with active orders.")
      throw(:abort)
    end
  end

  has_one :cart, dependent: :destroy
  enum :role, { customer: 0, admin: 1, manager: 2 }, default: :customer
  has_one_attached :profile_picture
  
  attr_accessor :cropped_image_data
end