class CartController < ApplicationController
    before_action :initialize_add_cart_usecase, only: [:add]
    before_action :initialize_clear_cart_usecase, only: [:clear]
    before_action :initialize_load_cart_usecase, only: [:index]

    def index
        begin
            @carts = @load_cart_use_case.load(@current_user.id)
            render json: @carts, status: :ok
        rescue BadRequestException => e
            render json: {error: e.message}, status: e.status
        rescue => e
            render json: {error: e.message}, status: :internal_server_error
        end
    end

    def add
      begin
        @cart = @add_cart_use_case.add(add_cart_params, @current_user)
        render json: @cart, status: :created
      rescue BadRequestException => e
        render json: {error: e.message}, status: e.status
      rescue => e
        render json: {error: e.message}, status: :internal_server_error
      end
    end

    def clear
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

    def delete
        Cart.where(id: params[:id]).destroy_all
        render status: :no_content
    end

    def update
        cart = Cart.find(params[:id])

        if cart.update(add_cart_params)
            render json: @cart
        else
            render json: @cart.errors, status: :unprocessable_entity
        end
    end

    private
    def add_cart_params
      params.require(:cart).permit(:stripe_product_id, :quantity)
    end

    def initialize_add_cart_usecase
      @add_cart_use_case = Cart::AddCartUseCase.new
    end

    def initialize_clear_cart_usecase
        @clear_cart_use_case = Cart::ClearCartUseCase.new
    end
end
  