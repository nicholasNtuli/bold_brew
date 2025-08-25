class CheckoutsController < ApplicationController
    before_action :authenticate_user!

    def create
        cart = current_user.cart || Cart.find_by(session_id: session.id.to_s)
        line_items = cart.line_items.includes(:product)
        
        session_params = {
            mode: 'payment',
            success_url: orders_url + '?success=1',
            cancel_url: cart_url,
            line_items: line_items.map do |li|
                {
                    quantity: li.quantity,
                        price_data: {
                        currency: li.product.currency,
                        unit_amount: li.unit_price_cents,
                        product_data: {
                            name: li.product.name,
                            images: li.product.images.map { |img| url_for(img) } rescue []
                        }
                    }
                }
            end
        }

        session = Stripe::Checkout::Session.create(session_params)
        
        order = Order.create!(
            user: current_user,
            status: 'pending',
            total_cents: cart.total_cents,
            currency: line_items.first&.product&.currency || 'usd',
            checkout_session_id: session.id
        )

        redirect_to session.url, allow_other_host: true
    end
end