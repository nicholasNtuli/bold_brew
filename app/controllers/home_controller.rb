class HomeController < ApplicationController
  def index
    @featured = Product.active.limit(8)
    @categories = Category.all
  end
end