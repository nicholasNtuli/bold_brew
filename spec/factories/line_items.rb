FactoryBot.define do
  factory :line_item do
    cart { nil }
    product { nil }
    quantity { 1 }
    unit_price_cents { 1 }
  end
end
