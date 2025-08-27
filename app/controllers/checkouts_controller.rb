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

        # Create the line items array for Stripe from the cart's line items.
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
            success_url: orders_url + '?success=1',
            cancel_url: cart_url,
            line_items: line_items_for_stripe
        }
        
        # This will create a new Stripe Checkout Session.
        session = Stripe::Checkout::Session.create(session_params)

        # Create a new Order in your database.
        order = Order.create!(
            user: current_user,
            status: 'pending',
            total_cents: @cart.total_cents,
            currency: @cart.line_items.first.product.currency,
            checkout_session_id: session.id
        )

        # Redirect the user to the Stripe Checkout page.
        redirect_to session.url, allow_other_host: true
    end
end