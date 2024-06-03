class Product::LoadProductsUseCase
    def initialize
        @stripe_service = StripeService.new
    end

    def load_products(ids)
        if ids.present?
            list_products = @stripe_service.list_products_by_ids(ids.split(","))
            return list_products
        end

        prices = @stripe_service.list_price()

        @stripe_service.list_products(prices)
    end
end