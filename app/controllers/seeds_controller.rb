class SeedsController < ApplicationController
  # Prevent unauthorized access
  before_action :authorize_seed_key

  def run
    # Seed categories & products
    coffee = Category.find_or_create_by!(name: "Coffee")
    flavors = [
      { name: "Bold Brew Original", price_cents: 1499 },
      { name: "Vanilla Cold Brew", price_cents: 1599 },
      { name: "Mocha Cold Brew", price_cents: 1599 },
      { name: "Caramel Cold Brew", price_cents: 1699 }
    ]

    flavors.each do |f|
      Product.find_or_create_by!(name: f[:name]) do |p|
        p.category = coffee
        p.description = "Smooth, low‑acid cold brew."
        p.price_cents = f[:price_cents]
        p.currency = "zar"
        p.sku = SecureRandom.hex(4)
        p.stock = 50
        p.active = true
      end
    end

    # Seed admin user
    User.find_or_create_by!(email: "admin@boldbrew.com") do |user|
      user.password = "SecurePassword123!"
      user.password_confirmation = "SecurePassword123!"
      user.role = :admin
    end

    render plain: "Seeded successfully!"
  end

  private

  def authorize_seed_key
    head(:forbidden) unless params[:key] == ENV["SEED_KEY"]
  end
end
