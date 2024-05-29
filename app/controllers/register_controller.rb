class RegisterController < ApplicationController
    skip_before_action :authorized, only: [:register]
    require './app/use_cases/auth/register_use_case'
  
    def initialize
      @register_use_case = RegisterUseCase.new
    end
  
    def register
      @user = User.new(user_params)

      puts @user.inspect
  
      begin
        render json: @register_use_case.register(@user), status: :created
      rescue UnprocessableEntityException => e
        render json: {error: e.message}, status: e.status
      rescue BadRequestException => e
        render json: {error: e.message}, status: e.status
      rescue => e
        render json: {error: e.message}, status: :internal_server_error
      end
    end
    private

    def user_params
        params.require(:user).permit(:username, :password, :password_confirmation, :name, :email, :phone, :document, :role)
      end
  end
    