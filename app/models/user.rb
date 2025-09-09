class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  has_many :orders
  has_one :cart, dependent: :destroy
  enum :role, { customer: 0, admin: 1, manager: 2 }, default: :customer
  has_one_attached :profile_picture
  
  # Virtual attribute for handling cropped image data
  attr_accessor :cropped_image_data
end