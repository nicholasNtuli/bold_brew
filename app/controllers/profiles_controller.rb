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
      sign_out(@user)
      redirect_to root_path, notice: 'Your account has been successfully deleted.', status: :see_other
    else
      redirect_to profile_path, alert: 'There was a problem deleting your account.', status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :phone_number, :email, :password, :password_confirmation, :profile_picture)
  end
end
