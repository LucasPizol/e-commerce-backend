class Product::CreateProductController < ApplicationController
    before_action :permission_admin

    def initialize
        @create_product_use_case = Product::CreateProductUseCase.new
    end

    def handle
        begin
            product = @create_product_use_case.create(product_params)

            render json: product, status: :created
        rescue => e
            render json: {error: e.message}, status: :internal_server_error
        end
    end

    def product_params
        params.require(:product).permit(:name, :description, :price, metadata: {}, images: [])
    end
end