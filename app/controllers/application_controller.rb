class ApplicationController < ActionController::Base
  helper_method :current_cart
  before_action :clear_cart_on_sign_out

  private

  def current_cart
    @current_cart ||= if user_signed_in?
      Cart.find_or_create_by(user: current_user)
    else
      cart = Cart.find_by(id: session[:cart_id])
      if cart.nil?
        cart = Cart.create
        session[:cart_id] = cart.id
      end
      cart
    end
  end

  def clear_cart_on_sign_out
    # Clear cart when user signs out (detected by missing user but having a user-based cart in session)
    if !user_signed_in? && session[:user_cart_cleared] != true && session[:cart_id]
      # Find and destroy any session-based cart
      cart = Cart.find_by(id: session[:cart_id])
      if cart&.user_id.nil? # Only destroy session carts, not user carts
        cart.destroy
        session[:cart_id] = nil
      end
      session[:user_cart_cleared] = true
    elsif user_signed_in?
      session[:user_cart_cleared] = false
    end
  end
end