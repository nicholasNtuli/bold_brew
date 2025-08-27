Warden::Manager.after_authentication do |user, auth, opts|
  if auth.session[:cart_id]
    session_cart = Cart.find_by(id: auth.session[:cart_id])
    if session_cart && session_cart.user_id.nil?
      user_cart = Cart.find_or_create_by(user: user)
      
      # Transfer items to user cart
      session_cart.line_items.each do |item|
        user_cart.add(item.product, item.quantity)
      end
      
      # Destroy the now-empty guest cart
      session_cart.destroy
      auth.session[:cart_id] = nil
    end
  end
end

Warden::Manager.before_logout do |user, auth, opts|
  if user
    user_cart = user.cart
    if user_cart
      user_cart.line_items.destroy_all
    end
  end
end