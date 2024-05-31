class Product::ListProductsUseCase
    def initialize
        @stripe_service = StripeService.new
    end

    def list_products(ids)
        if ids.present?
            list_products = @stripe_service.list_products_by_ids(ids.split(","))
            return list_products
        end

        prices = @stripe_service.list_price()

        list_products = @stripe_service.list_products(prices)

        return list_products
    end
end