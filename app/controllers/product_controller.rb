class ProductController < ApplicationController
    before_action :permission_admin, except: [:index]
    before_action :initialize_add_product_usecase, only: [:add]
    before_action :initialize_load_product_usecase, only: [:index]
    before_action :initialize_update_product_usecase, only: [:update]

    def add
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

    def index
        begin
            ids=params[:ids]
            products = @load_products_use_case.load_products(ids)
            
            render json: products, status: :ok
        rescue => e
            render json: {error: e.message}, status: :internal_server_error
        end
    end

    def update
        begin
            product = @update_product_use_case.update_product(params[:id], product_params)
            render json: product, status: :ok
        rescue => e
            render json: {error: e.message}, status: :internal_server_error
        end
    end

    def initialize_add_product_usecase
        @create_product_use_case = Product::CreateProductUseCase.new(stripe_service: StripeService.new, aws_service: AwsService.new)
    end

    def initialize_load_product_usecase
        @load_products_use_case = Product::LoadProductsUseCase.new(stripe_service: StripeService.new)
    end

    def initialize_update_product_usecase
        @update_product_use_case = Product::UpdateProductUseCase.new(stripe_service: StripeService.new, aws_service: AwsService.new)
    end
end