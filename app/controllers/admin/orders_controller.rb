class Admin::OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_admin!
  before_action :set_order, only: [:show, :mark_as_paid, :mark_as_shipped, :cancel]

  def index
    @orders = Order.includes(:user, :order_items).order(created_at: :desc)
    
    @orders = @orders.where(status: params[:status]) if params[:status].present?
    
    if params[:search].present?
      @orders = @orders.joins(:user).where(
        "users.email ILIKE ? OR orders.id::text ILIKE ?", 
        "%#{params[:search]}%", "%#{params[:search]}%"
      )
    end
  end

  def show
  end

  def mark_as_paid
    if @order.may_pay?
      @order.pay!
      redirect_to admin_orders_path, notice: 'Order has been marked as paid.'
    else
      redirect_to admin_orders_path, alert: 'Order cannot be marked as paid.'
    end
  end

  def mark_as_shipped
    if @order.may_ship?
      @order.ship!
      redirect_to admin_orders_path, notice: 'Order has been marked as shipped.'
    else
      redirect_to admin_orders_path, alert: 'Order cannot be marked as shipped.'
    end
  end

  def cancel
    if @order.may_cancel?
      @order.cancel!
      redirect_to admin_orders_path, notice: 'Order has been cancelled.'
    else
      redirect_to admin_orders_path, alert: 'Order cannot be cancelled.'
    end
  end

  private

  def set_order
    @order = Order.find(params[:id])
  end

  def authorize_admin!
    unless current_user.admin?
      redirect_to root_path, alert: "You are not authorized to access this page."
    end
  end
end