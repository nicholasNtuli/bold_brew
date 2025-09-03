# app/controllers/products_controller.rb
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

    # Preload Active Storage images to prevent them from disappearing
    @q = base_scope.with_attached_images.ransack(params[:q])

    # NOTE: The hard-coded `.order(created_at: :desc)` will prevent Ransack sorting from working.
    # It's better to let Ransack handle sorting based on the URL parameter.
    # The correct line to use with Ransack would be:
    # @products = @q.result(distinct: true).includes(:category)
    @products = @q.result(distinct: true).includes(:category).order(created_at: :desc)
  end

  def show
    @product = Product.friendly.find(params[:id])
  end

  private

  def product_params
    params.require(:q).permit(:s) if params[:q]
  end
end