class Cart::AddCartController < ApplicationController
    def initialize
      @add_cart_use_case = Cart::AddCartUseCase.new
    end

    def handle
      begin
        @cart = @add_cart_use_case.add(cart_params, @current_user)
        render json: @cart, status: :created
      rescue BadRequestException => e
        render json: {error: e.message}, status: e.status
      rescue => e
        render json: {error: e.message}, status: :internal_server_error
      end
    end

    private
    def cart_params
      params.require(:cart).permit(:stripe_product_id, :quantity)
    end
  end
  