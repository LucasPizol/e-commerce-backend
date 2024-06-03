class Product::LoadProductsController < ApplicationController
    before_action :authorized, except: [:handle]

    def initialize
        @load_products_use_case = Product::LoadProductsUseCase.new
    end

    def handle
        begin
            ids=params[:ids]
            products = @load_products_use_case.load_products(ids)
            
            render json: products, status: :ok
        rescue => e
            render json: {error: e.message}, status: :internal_server_error
        end
    end
end