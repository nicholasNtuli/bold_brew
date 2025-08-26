class OrdersController < ApplicationController
    before_action :authenticate_user!

    def index
        @orders = current_user.orders.includes(:order_items).order(created_at: :desc)
    end

    def show
        @order = current_user.orders.find(params[:id])
    end

    def create
    @order = Order.new(order_params)
        if @order.save
          current_user.cart.destroy if current_user&.cart
          redirect_to orders_path, notice: 'Order was successfully created.'
        else
           super
        end
    end
end