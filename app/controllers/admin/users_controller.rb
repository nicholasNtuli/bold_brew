class Admin::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_admin!
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def index
    # Load all users and filter based on search and role parameters
    @users = User.order(created_at: :desc)
    
    # Search functionality
    if params[:search].present?
      @users = @users.where("email ILIKE ?", "%#{params[:search]}%")
    end

    # Filter by role
    if params[:role].present? && User.roles.keys.include?(params[:role])
      @users = @users.where(role: params[:role])
    end
  end

  def show
  end

  def edit
  end

  def update
    # Use a specific set of strong parameters for admin user updates
    if @user.update(admin_user_params)
      redirect_to admin_user_path(@user), notice: 'User was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy
    redirect_to admin_users_path, notice: 'User was successfully deleted.', status: :see_other
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def admin_user_params
    params.require(:user).permit(:role, :email)
  end
end
