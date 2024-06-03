class Cart::ClearCartController < ApplicationController
    def initialize
      @clear_cart_use_case = Cart::ClearCartUseCase.new
    end

    def handle
      begin
        token = params.permit(:token)
  
        @clear_cart_use_case.clear(@current_user.id, token[:token])
        render json: {message: "Cart cleared"}, status: :ok
      rescue BadRequestException => e
        render json: {error: e.message}, status: e.status
      rescue => e
        render json: {error: e.message}, status: :internal_server_error
      end
    end
  end
  