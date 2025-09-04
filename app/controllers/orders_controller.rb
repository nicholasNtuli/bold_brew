class OrdersController < ApplicationController
    before_action :authenticate_user!
    before_action :set_order, only: [:show, :cancel]

    def index
        @orders = current_user.orders.includes(:order_items).order(created_at: :desc)
        
        # Filter by status if provided
        if params[:status].present?
            @orders = @orders.where(status: params[:status])
        end
    end

    def show
    end

    def cancel
        if @order.may_cancel?
            @order.cancel!
            redirect_to orders_path, notice: 'Order has been cancelled successfully.'
        else
            redirect_to orders_path, alert: 'This order cannot be cancelled.'
        end
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

    private

    def set_order
        @order = current_user.orders.find(params[:id])
    end

    def order_params
        params.require(:order).permit(:total_cents, :currency, :status)
    end
end