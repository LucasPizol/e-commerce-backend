class Product::LoadProductsUseCase
    def initialize(stripe_service: StripeService)
        @stripe_service = stripe_service
    end

    def load_products(ids)

        prices = @stripe_service.list_price()

        if ids.present?
            list_products = @stripe_service.list_products_by_ids(ids.split(","), prices)
            return list_products
        end

        @stripe_service.list_products(prices)
    end
end