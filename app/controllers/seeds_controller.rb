class SeedsController < ApplicationController
  # Prevent unauthorized access
  before_action :authorize_seed_key

  def run
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
