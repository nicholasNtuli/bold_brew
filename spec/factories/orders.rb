FactoryBot.define do
  factory :order do
    user { nil }
    status { "MyString" }
    total_cents { 1 }
    currency { "MyString" }
    checkout_session_id { "MyString" }
    payment_intent_id { "MyString" }
  end
end
