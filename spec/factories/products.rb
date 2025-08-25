FactoryBot.define do
  factory :product do
    category { nil }
    name { "MyString" }
    slug { "MyString" }
    description { "MyText" }
    price_cents { 1 }
    currency { "MyString" }
    sku { "MyString" }
    stock { 1 }
    active { false }
  end
end
