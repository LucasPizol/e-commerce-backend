class Product::CreateProductUseCase
    require './app/services/stripe_service'
    require './app/services/aws_service'

    def initialize(stripe_service: StripeService, aws_service: AwsService)
        @stripe_service = stripe_service
        @aws_service = aws_service
    end

    def create(product_params)
        images = []

        if product_params[:images]
            product_params[:images].map do |image|
                extension = File.extname(image.original_filename)
                image = @aws_service.insert(image, "products/#{product_params[:name].parameterize}/#{image.original_filename.gsub(extension, "")}-#{SecureRandom.uuid}#{extension}")
                images.push(image)
            end
        end

        @stripe_service.create_product({
            name: product_params["name"],
            description: product_params["description"],
            metadata: product_params["metadata"],
            price: product_params["price"],
            images: images
        })
    end
end