class ProductsController < ApplicationController
    before_action :authorized, except: [:list, :create]

    def initialize
        @list_products_use_case = Product::ListProductsUseCase.new
        @create_product_use_case = Product::CreateProductUseCase.new
        @update_product_use_case = Product::UpdateProductUseCase.new
    end

    def list
        begin
            ids=params[:ids]
            products = @list_products_use_case.list_products(ids)
            
            render json: products, status: :ok
        rescue => e
            render json: {error: e.message}, status: :internal_server_error
        end
    end

    def create
        begin
            product = @create_product_use_case.create(product_params)

            render json: product, status: :created
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

    def product_params
        params.require(:product).permit(:name, :description, :price, metadata: {}, images: [])
    end
end