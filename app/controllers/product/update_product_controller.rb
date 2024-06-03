class Product::UpdateProductController < ApplicationController
    before_action :permission_admin

    def initialize
        @update_product_use_case = Product::UpdateProductUseCase.new
    end

    def handle
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