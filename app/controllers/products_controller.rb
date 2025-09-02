class ProductsController < ApplicationController
  include Pagy::Backend

  def index
    @categories = Category.all

    if params[:category].present?
      @category = Category.find_by(name: params[:category])
      if @category
        base_scope = @category.products.active
      else
        base_scope = Product.none
      end
    else
      base_scope = Product.active
    end

    @q = base_scope.ransack(params[:q])
    @products = @q.result.includes(:category).order(created_at: :desc)
  end

  def show
    @product = Product.friendly.find(params[:id])
  end
end
