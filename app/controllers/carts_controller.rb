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
        li.update!(quantity: params[:quantity])
        respond_to do |format|
            format.turbo_stream
            format.html { redirect_to cart_path }
        end
    end
    
    def remove_item
        li = @cart.line_items.find(params[:id])
        li.destroy
        respond_to do |format|
            7
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
            @cart = Cart.find_or_create_by(user: current_user)
        else
            @cart = Cart.find_or_create_by(session_id: session.id.to_s)
        end
    end
end