class Product::ListProductsByIdUseCase
    def initialize
        @stripe_service = StripeService.new
    end

    def list_products_by_ids(ids)
        prices = @stripe_service.list_price().data
         @stripe_service.list_products_by_ids(ids, prices)
    end
end