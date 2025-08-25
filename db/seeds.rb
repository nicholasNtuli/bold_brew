# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

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
        p.currency = "usd"
        p.sku = SecureRandom.hex(4)
        p.stock = 50
        p.active = true
    end
end