class ApplicationController < ActionController::Base
  helper_method :current_cart

  private

  def current_cart
    @current_cart ||= if session[:cart_id].present?
      Cart.find_by(id: session[:cart_id]) || (user_signed_in? && Cart.find_or_create_by(user: current_user))
    elsif user_signed_in?
      Cart.find_or_create_by(user: current_user)
    else
      cart = Cart.create
      session[:cart_id] = cart.id
      cart
    end
  end

  private

  def after_sign_in_path_for(resource)
    stored_location = session[:user_return_to]
    stored_location || root_path
  end
end