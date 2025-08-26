if Rails.env.development? || Rails.env.test?
  require 'dotenv/load'
end

Stripe.api_key = ENV['STRIPE_SECRET_KEY']