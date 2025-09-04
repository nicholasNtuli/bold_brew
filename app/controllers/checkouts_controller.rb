class CheckoutsController < ApplicationController
    before_action :authenticate_user!

    def show
      @cart = current_cart
    end

    def create
        @cart = current_cart

        if @cart.line_items.empty?
            redirect_to cart_path, alert: "Your cart is empty and cannot be checked out."
            return
        end
        
        line_items_for_stripe = @cart.line_items.includes(:product).map do |line_item|
            {
                quantity: line_item.quantity,
                price_data: {
                    currency: line_item.product.currency,
                    unit_amount: line_item.unit_price_cents,
                    product_data: {
                        name: line_item.product.name,
                        images: (line_item.product.images.attached? ? line_item.product.images.map { |img| url_for(img) } : [])
                    }
                }
            }
        end

        session_params = {
            mode: 'payment',
            success_url: checkouts_success_url + '?session_id={CHECKOUT_SESSION_ID}',
            cancel_url: cart_url,
            line_items: line_items_for_stripe
        }
        
        session = Stripe::Checkout::Session.create(session_params)

        order = Order.create!(
            user: current_user,
            status: 'pending',
            total_cents: @cart.total_cents,
            currency: @cart.line_items.first.product.currency,
            checkout_session_id: session.id
        )

        redirect_to session.url, allow_other_host: true
    end

    def success
        ActiveRecord::Base.transaction do
            stripe_session = Stripe::Checkout::Session.retrieve(params[:session_id])
            order = Order.find_by!(checkout_session_id: stripe_session.id)

            order.update!(status: 'paid')
            
            current_cart.line_items.each do |line_item|
                order.order_items.create!(
                    product: line_item.product,
                    quantity: line_item.quantity,
                    unit_price_cents: line_item.unit_price_cents
                )

                product = line_item.product
                product.stock -= line_item.quantity
                product.save!
            end

            current_cart.destroy!

            redirect_to order_path(order), notice: "Your order has been placed successfully!"
        end
    rescue ActiveRecord::RecordInvalid => e
        redirect_to cart_path, alert: "There was an issue processing your order. Please try again. Error: #{e.message}"
    end
end
