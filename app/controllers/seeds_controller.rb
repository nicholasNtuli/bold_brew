class SeedsController < ApplicationController
  skip_before_action :verify_authenticity_token  

  def run
    if params[:key] == ENV['SEED_KEY']
      begin
        Rails.application.load_seed
        render json: { message: 'Database seeded successfully.' }, status: :ok
      rescue => e
        render json: { error: "Failed to seed database: #{e.message}" }, status: :unprocessable_entity
      end
    else
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end
end
