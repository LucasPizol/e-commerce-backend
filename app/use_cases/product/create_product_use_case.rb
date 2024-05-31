class Product::CreateProductUseCase
    require './app/services/stripe_service'
    require './app/services/aws_service'

    def initialize
        @stripe_service = StripeService.new
        @aws_service = AwsService.new
    end

    def create(product_params)

        images = []

        if product_params[:images]
            product_params[:images].map do |image|
                images.push(@aws_service.insert(image, "products/#{product_params[:name]}/#{image.original_filename}"))
            end
        end

        stripe_product = @stripe_service.create_product({**product_params, images: images})

        return stripe_product
    end

end