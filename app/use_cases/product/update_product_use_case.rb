class Product::UpdateProductUseCase
    def initialize
        @stripe_service = StripeService.new
    end

    def update_product(product, data)
        @stripe_service.update_product(product, data)
    end
end