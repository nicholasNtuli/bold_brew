Warden::Manager.after_authentication do |user, auth, opts|
  # Optional: Transfer session cart to user cart when signing in
  # This preserves items added while signed out
  if auth.session[:cart_id]
    session_cart = Cart.find_by(id: auth.session[:cart_id])
    if session_cart && session_cart.user_id.nil?
      # Transfer items to user cart or destroy session cart
      user_cart = Cart.find_or_create_by(user: user)
      
      # Option A: Transfer items (uncomment if you want to preserve session cart items)
      # session_cart.line_items.each do |item|
      #   user_cart.add(item.product, item.quantity)
      # end
      
      # Option B: Just destroy the session cart (recommended for fresh start)
      session_cart.destroy
      auth.session[:cart_id] = nil
    end
  end
end

Warden::Manager.before_logout do |user, auth, opts|
  # Clear user's cart on logout
  if user
    user_cart = user.cart
    if user_cart
      # Option A: Empty cart but keep it
      user_cart.line_items.destroy_all
      
      # Option B: Destroy cart completely (uncomment this and comment above if preferred)
      # user_cart.destroy
    end
  end
end