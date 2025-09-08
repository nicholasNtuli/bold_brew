class ApplicationController < ActionController::Base
  helper_method :current_cart
  protect_from_forgery with: :exception

  def authorize_admin!
    unless current_user&.admin?
      redirect_to root_path, alert: "You are not authorized to view this page."
    end
  end

  def current_cart
    # Find cart by session, or find/create for logged-in user, or create a new cart
    @current_cart ||= if user_signed_in?
      Cart.find_or_create_by(user: current_user)
    elsif session[:cart_id].present?
      Cart.find_by(id: session[:cart_id]) || Cart.create
    else
      cart = Cart.create
      session[:cart_id] = cart.id
      cart
    end
    session[:cart_id] = @current_cart.id if @current_cart.persisted?
    @current_cart
  end

  private

  def after_sign_in_path_for(resource)
    stored_location = session[:user_return_to]
    stored_location || root_path
  end
end