class ApplicationController < ActionController::Base
  helper_method :current_cart

  private

  def current_cart
    @current_cart ||= if session[:cart_id].present?
      # Prioritize finding a guest cart from the session first
      Cart.find_by(id: session[:cart_id]) || (user_signed_in? && Cart.find_or_create_by(user: current_user))
    elsif user_signed_in?
      # If no guest cart, find or create the user's cart
      Cart.find_or_create_by(user: current_user)
    else
      # For new guests, create a new cart
      cart = Cart.create
      session[:cart_id] = cart.id
      cart
    end
  end
end