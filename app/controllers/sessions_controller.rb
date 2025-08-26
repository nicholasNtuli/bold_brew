# app/controllers/users/sessions_controller.rb
class Users::SessionsController < Devise::SessionsController
  protected

  def after_sign_in_path_for(resource)
    # Set flag to indicate user just signed in (for cart cleanup)
    session[:just_signed_in] = true
    super
  end

  def after_sign_out_path_for(resource_or_scope)
    # Clear user's cart on sign out
    if resource_or_scope.is_a?(User) && resource_or_scope.cart
      resource_or_scope.cart.line_items.destroy_all
      # Or destroy the cart entirely:
      # resource_or_scope.cart.destroy
    end
    
    # Also clear any session cart data
    session.delete(:cart_id)
    session.delete(:just_signed_in)
    
    super
  end
end