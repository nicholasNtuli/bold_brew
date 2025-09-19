class ApplicationController < ActionController::Base
  helper_method :current_cart
  protect_from_forgery with: :exception

  def authorize_admin!
    unless current_user&.admin?
      redirect_to root_path, alert: "You are not authorized to view this page."
    end
  end

  def current_cart
    @current_cart ||= if user_signed_in?
      current_user.cart || current_user.create_cart
    elsif session[:cart_id].present?
      Cart.find_by(id: session[:cart_id]) || create_guest_cart
    else
      create_guest_cart
    end
  end

  private

  def after_sign_in_path_for(resource)
    stored_location = session[:user_return_to]
    stored_location || root_path
  end

  def after_sign_out_path_for(resource_or_scope)
    session[:cart_id] = nil
    root_path
  end

  def create_guest_cart
    cart = Cart.create
    session[:cart_id] = cart.id
    cart
  end
end