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

    if params[:user][:password].blank? && params[:user][:password_confirmation].blank?
      params[:user].extract!(:password, :password_confirmation)
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
    params.require(:user).permit(:username, :phone_number, :email, :password, :password_confirmation, :profile_picture)
  end
end
