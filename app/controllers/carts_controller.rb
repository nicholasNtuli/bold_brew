class CartsController < ApplicationController
  def show
    @cart = current_cart
  end

  def add_item
    product = Product.friendly.find(params[:product_id])
    current_cart.add(product, params[:quantity] || 1)
    redirect_to cart_path, notice: "Added to cart"
  end

  def update_item
    li = current_cart.line_items.find(params[:id])
    li.update!(quantity: params[:cart][:quantity])
    redirect_to cart_path, notice: "Cart updated"
  end
  
  def remove_item
    li = current_cart.line_items.find(params[:id])
    li.destroy
    redirect_to cart_path, notice: "Item removed from cart"
  end

  def empty
    current_cart.line_items.delete_all
    redirect_to cart_path, notice: "Cart emptied"
  end
end