class Cart::LoadCartUseCase 
    require "./app/services/stripe_service"

    def initialize
        @stripe_service = StripeService.new
    end

    def load(user_id)

        carts = Cart.all.where(user_id: user_id)

 

        prices = @stripe_service.list_price().data

        cart_with_aggregation = @stripe_service.list_products_by_ids(carts.map(&:stripe_product_id), prices)


        if cart_with_aggregation.empty?
            return []
        end


        cart_with_aggregation.map do |product|
          cart = carts.find { |cart| cart.stripe_product_id == product[:id] }
          {
            **cart,
            price: product[:price],
            name: product[:name],
            description: product[:description],
            images: product[:images]
          }
        end
    end

end