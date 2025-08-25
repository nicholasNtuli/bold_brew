class CategoriesController < ApplicationController
  def show
    @category = Category.friendly.find(params[:id])
    @pagy, @products = pagy(@category.products.active.order(created_at: :desc), items: 12)
  end
end
