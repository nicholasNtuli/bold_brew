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
    if params[:user][:cropped_image_data].present?
      image_data = params[:user][:cropped_image_data]
      decoded_image = Base64.decode64(image_data.split(",")[1])

      filename = "profile_#{@user.id}.png"
      tempfile = Tempfile.new([filename, ".png"])
      tempfile.binmode
      tempfile.write(decoded_image)
      tempfile.rewind

      @user.profile_picture.attach(io: tempfile, filename: filename, content_type: "image/png")
    end

    if @user.update(user_params)
      redirect_to @user, notice: "Profile updated!"
    else
      render :edit
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

  private
  def admin_user_params
    params.require(:user).permit(:role, :email, :username, :phone_number, :password, :password_confirmation, :cropped_image_data, :profile_picture)
  end
end
