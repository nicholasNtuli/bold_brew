class ProductsController < ApplicationController
  include Pagy::Backend
  
  def index
    @q = Product.active.ransack(params[:q])
    @products = @q.result.includes(:category).order(created_at: :desc)
    @pagy, @products = pagy(@products, items: 12)
    @categories = Category.all
  end

  def show
    @product = Product.friendly.find(params[:id])
  end
end
