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
    if @user.update(profile_params)
      redirect_to profile_path, notice: 'Your profile was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy_account
    @user = current_user
    if @user.destroy
      # Sign out the user after they delete their account
      sign_out(@user)
      redirect_to root_path, notice: 'Your account has been successfully deleted.', status: :see_other
    else
      redirect_to profile_path, alert: 'There was a problem deleting your account.', status: :unprocessable_entity
    end
  end

  private

  def profile_params
    # Allows a user to update their email
    params.require(:user).permit(:email)
  end
end
