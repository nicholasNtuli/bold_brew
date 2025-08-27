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
      # If a user is signed in, always use their dedicated cart.
      @cart = Cart.find_or_create_by(user: current_user)
    elsif session[:cart_id]
      # If a guest has a cart, find it using the session ID.
      @cart = Cart.find_by(id: session[:cart_id]) || Cart.create(session_id: session.id.to_s)
    else
      # If no user and no guest cart, create a new guest cart.
      @cart = Cart.create(session_id: session.id.to_s)
    end
    # Ensure the session[:cart_id] is set correctly for guests.
    session[:cart_id] = @cart.id unless current_user
  end
end