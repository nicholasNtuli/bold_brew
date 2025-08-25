FactoryBot.define do
  factory :order_item do
    order { nil }
    product { nil }
    name { "MyString" }
    unit_price_cents { 1 }
    quantity { 1 }
    subtotal_cents { 1 }
  end
end
