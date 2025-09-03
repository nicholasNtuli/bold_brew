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
    @products = @q.result(distinct: true).includes(:category)
  end

  def show
    @product = Product.friendly.find(params[:id])
  end

  private

  def product_params
    params.require(:q).permit(:s) if params[:q]
  end
end