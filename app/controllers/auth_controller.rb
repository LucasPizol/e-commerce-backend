class AuthController < ApplicationController
  skip_before_action :authorized, only: [:login]
  require './app/use_cases/auth/auth_use_case'
  require './app/use_cases/auth/register_use_case'
  require './app/use_cases/cart/load_cart_use_case'

  def initialize
    @auth_usecase = AuthUseCase.new
    @load_cart_use_case = Cart::LoadCartUseCase.new
  
  end

  def verify
    if @current_user
      cart = @load_cart_use_case.load(@current_user.id)
      return render json: {user: @current_user, cart: cart}, status: :ok
    end

    render json: {error: "Unauthorized"}, status: :unauthorized
  end

  def login
    begin
      response = @auth_usecase.login(user_params[:user_credential], user_params[:password])
      cart = @load_cart_use_case.load(response[:id])

      render json: {user: response, cart: cart}, status: :ok
    rescue UnauthorizedException => e
      render json: {error: e.message}, status: e.status
    rescue StandardError => e
      render json: {error: e.message}, status: :internal_server_error
    end
  end

  def user_params
    params.require(:user).permit(:user_credential, :password)
  end
end
  