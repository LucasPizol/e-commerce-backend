class Cart::AddCartUseCase 
    require "./app/services/stripe_service"

    def initialize
        @stripe_service = StripeService.new
    end

    def add(cart_params, user)
        cart = Cart.new({**cart_params, user_id: user.id})

        if cart.save
            prices = @stripe_service.list_price().data

            cart_with_aggregation = @stripe_service.list_products_by_ids([cart.stripe_product_id], prices)[0]
            {
                **cart.as_json,
                price: cart_with_aggregation[:price],
                name: cart_with_aggregation[:name],
                description: cart_with_aggregation[:description],
                images: cart_with_aggregation[:images]
            }
        else
            raise BadRequestException.new(@cart.errors)
        end
    end
end