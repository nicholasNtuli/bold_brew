class StaticPagesController < ApplicationController
  def home
  end

  def about
  end

  def contact
  end
  
  def cleanup_images
    Product.all.each do |product|
      if product.images.attached?
        product.images.purge
      end
    end
    redirect_to root_path, notice: "All broken product image links have been removed."
  end
end