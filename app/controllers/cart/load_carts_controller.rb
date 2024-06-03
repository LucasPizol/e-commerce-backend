class Cart::LoadCartsController < ApplicationController
    def initialize
        @load_cart_use_case = Cart::LoadCartUseCase.new
    end
  
    def handle
        @carts = @load_cart_use_case.load(@current_user.id)
        render json: @carts, status: :ok
    end
  
    private
    def cart_params
        params.require(:cart).permit(:stripe_product_id, :quantity)
    end
  end
  