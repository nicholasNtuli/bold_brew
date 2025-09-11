class Admin::ProductsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_admin!
  before_action :set_product, only: %i[ edit update destroy destroy_image ] 

  def index
    @categories = Category.all.order(:name)
    
    @q = Product.ransack(params[:q])
    @products = @q.result(distinct: true).includes(:category)
  end

  def new
    @product = Product.new(stock: 1)
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      redirect_to admin_products_path, notice: 'Product was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
  product_attributes = product_params.except(:images)
  new_images = params[:product][:images]

    if @product.update(product_attributes)
      if new_images.present?
        @product.images.attach(new_images)
      end
      redirect_to admin_products_path, notice: 'Product was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def show
    redirect_to admin_products_path
  end

  def destroy
    @product.destroy
    redirect_to admin_products_path, notice: 'Product was successfully deleted.', status: :see_other
  end

  def destroy_image
    image = @product.images.find(params[:image_id])
    image.purge
    redirect_to edit_admin_product_path(@product), notice: "Image was successfully deleted."
  end

  private

  def set_product
    @product = Product.friendly.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:name, :description, :price_cents, :currency, :category_id, :stock, :active, images: [])
  end

  def purge_all_images
    Product.find_each { |p| p.images.purge }
    render plain: "All product images purged!"
  end
end