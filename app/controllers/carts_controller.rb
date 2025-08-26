class CartsController < ApplicationController
  before_action :load_cart

  def show; end

  def add_item
    product = Product.friendly.find(params[:product_id])
    @cart.add(product, params[:quantity] || 1)
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to cart_path, notice: "Added to cart" }
    end
  end

  def update_item
    li = @cart.line_items.find(params[:id])
    li.update!(quantity: params[:cart][:quantity])
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to cart_path }
    end
  end
  
  def remove_item
    li = @cart.line_items.find(params[:id])
    li.destroy
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to cart_path }
    end
  end

  def empty
    @cart.line_items.delete_all
    redirect_to cart_path, notice: "Cart emptied"
  end

  private

  def load_cart
    if current_user
      # User is signed in - use user cart
      @cart = Cart.find_or_create_by(user: current_user)
      
      # If user just signed in, clear any existing items for fresh start
      if session[:just_signed_in]
        @cart.line_items.destroy_all
        session.delete(:just_signed_in)
      end
      
      # Clear any session cart that might exist
      if session[:cart_id]
        session_cart = Cart.find_by(id: session[:cart_id])
        session_cart&.destroy if session_cart&.user_id.nil?
        session.delete(:cart_id)
      end
    else
      # User is not signed in - use session cart
      @cart = Cart.find_or_create_by(session_id: session.id.to_s)
    end
  end
end