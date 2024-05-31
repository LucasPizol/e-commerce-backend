class CartsController < ApplicationController
  before_action :set_cart, only: %i[ show update destroy ]

  require './app/use_cases/cart/load_cart_use_case'
  require './app/use_cases/cart/add_cart_use_case'
  require './app/use_cases/cart/clear_cart_use_case'

  def initialize
    @load_cart_use_case = Cart::LoadCartUseCase.new
    @add_cart_use_case = Cart::AddCartUseCase.new
    @clear_cart_use_case = Cart::ClearCartUseCase.new
  end

  # GET /carts
  def index
    @carts = @load_cart_use_case.load(@current_user.id)

    render json: @carts, status: :ok
  end

  # GET /carts/1
  def show
    render json: @cart
  end

  # POST /carts
  def create
    begin
      @cart = @add_cart_use_case.add(cart_params, @current_user)
      render json: @cart, status: :created
    rescue BadRequestException => e
      render json: {error: e.message}, status: e.status
    rescue => e
      render json: {error: e.message}, status: :internal_server_error
    end
  end

  # PATCH/PUT /carts/1
  def update
    if @cart.update(cart_params)
      render json: @cart
    else
      render json: @cart.errors, status: :unprocessable_entity
    end
  end

  # DELETE /carts/1
  def destroy
    @cart.destroy!
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cart
      @cart = Cart.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def cart_params
      params.require(:cart).permit(:stripe_product_id, :quantity)
    end
end
