class SearchController < ApplicationController
  def index
    @query = params[:q]&.strip
    @category = params[:category]
    
    if @query.present?
      base_scope = Product.active.with_attached_images.includes(:category)
      
      if @category.present? && @category != 'all'
        category_obj = Category.find_by(name: @category)
        base_scope = base_scope.where(category: category_obj) if category_obj
      end
      
      @products = base_scope.where(
        "name ILIKE ? OR description ILIKE ?", 
        "%#{@query}%", 
        "%#{@query}%"
      ).order(created_at: :desc)
      
      @total_results = @products.count
    else
      @products = Product.none
      @total_results = 0
    end
    
    @categories = Category.all
    
    respond_to do |format|
      format.html
      format.json do
        render json: {
          products: @products.limit(5).map do |product|
            {
              id: product.id,
              name: product.name,
              price: number_to_currency(product.price_cents / 100.0, unit: 'R'),
              category: product.category.name,
              url: product_path(product),
              image_url: product.images.attached? ? url_for(product.images.first.variant(resize_to_fill: [100, 100]).processed) : nil
            }
          end,
          total_results: @total_results,
          query: @query
        }
      end
    end
  end
end