class SeedsController < ApplicationController
  skip_before_action :verify_authenticity_token  
  def run
    if params[:key] == ENV['SEED_API_KEY']
      begin
        # Ensure the admin user exists
        admin = User.find_or_initialize_by(email: 'admin@boldbrew.com')
        admin.password = 'SecurePassword123!'
        admin.password_confirmation = 'SecurePassword123!'
        admin.role = :admin
        admin.save!

        render json: { message: 'Admin user seeded successfully.' }, status: :ok
      rescue => e
        render json: { error: "Failed to seed admin user: #{e.message}" }, status: :unprocessable_entity
      end
    else
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end
end
