class Product::UpdateProductUseCase
    def initialize(stripe_service: StripeService, aws_service: AwsService)
        @stripe_service = stripe_service
        @aws_service = aws_service
    end

    def update_product(product, data)
        @stripe_service.update_product(product, data)
    end
end