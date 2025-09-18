class ProfilesController < ApplicationController
  before_action :authenticate_user!
  
  def show
    @user = current_user
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user

    # Check if user params exist and handle password fields
    if params[:user].present?
      if params[:user][:password].blank? && params[:user][:password_confirmation].blank?
        params[:user].extract!(:password, :password_confirmation)
      end
      
      # Handle cropped image data if present (remove it from params before updating)
      cropped_image_data = params[:user].delete(:cropped_image_data)
      
      if cropped_image_data.present?
        handle_cropped_image(cropped_image_data)
      end
    end

    if @user.update(user_params)
      redirect_to profile_path, notice: 'Profile updated successfully.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy_account
    @user = current_user

    if @user.destroy
      reset_session
      respond_to do |format|
        format.html { redirect_to root_path, notice: "Your account has been successfully deleted." }
        format.turbo_stream { redirect_to root_path, notice: "Your account has been successfully deleted." }
      end
    else
      # If destroy is aborted (user has orders)
      error_message = @user.errors.full_messages.to_sentence.presence || "Cannot delete account."
      respond_to do |format|
        format.html { redirect_to profile_path, alert: error_message, status: :unprocessable_entity }
        format.turbo_stream do
          flash.now[:alert] = error_message
          render turbo_stream: turbo_stream.replace("flash", partial: "shared/flash")
        end
      end
    end
  end

  private

  def user_params
    # Return empty hash if no user params present
    return {} unless params[:user].present?
    
    # Only permit actual User model attributes
    params.require(:user).permit(:username, :phone_number, :email, :password, :password_confirmation, :profile_picture)
  end

  def handle_cropped_image(image_data)
    return unless image_data.present?

    # Extract the actual base64 data (remove the data:image/jpeg;base64, prefix)
    if image_data.include?(',')
      encoded_image = image_data.split(',')[1]
    else
      encoded_image = image_data
    end

    # Decode and create a temporary file
    decoded_image = Base64.decode64(encoded_image)
    
    # Create a StringIO object to mimic a file
    temp_file = StringIO.new(decoded_image)
    temp_file.class.class_eval { attr_accessor :original_filename, :content_type }
    temp_file.original_filename = "cropped_profile_image.jpg"
    temp_file.content_type = "image/jpeg"
    
    # Attach the cropped image
    @user.profile_picture.attach(
      io: temp_file,
      filename: "profile_#{@user.id}_#{Time.current.to_i}.jpg",
      content_type: "image/jpeg"
    )
  rescue => e
    Rails.logger.error "Error processing cropped image: #{e.message}"
    @user.errors.add(:profile_picture, "Failed to process cropped image")
  end
end