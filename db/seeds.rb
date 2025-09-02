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
        p.currency = "zar"
        p.sku = SecureRandom.hex(4)
        p.stock = 50
        p.active = true
    end
end

puts "Creating categories..."
category1 = Category.create!(name: 'Coffee Beans', description: 'Freshly roasted coffee beans from around the world.')
category2 = Category.create!(name: 'Brewing Equipment', description: 'Tools for brewing the perfect cup.')

puts "Creating products..."
Product.create!(
  name: "Espresso Blend",
  description: "A rich and full-bodied espresso blend.",
  price: 1500, # Price in cents
  category: category1,
  active: true,
  currency: 'zar'
)

Product.create!(
  name: "Pour-Over Dripper",
  description: "Ceramic pour-over dripper for a clean brew.",
  price: 2500, # Price in cents
  category: category2,
  active: true,
  currency: 'zar'
)

puts "Database seeded successfully!"
