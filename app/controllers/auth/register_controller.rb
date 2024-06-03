class Auth::RegisterController < ApplicationController
    skip_before_action :authorized, only: [:handle]
  
    def initialize
      @register_use_case = Auth::RegisterUseCase.new
    end
  
    def handle
      begin
        render json: @register_use_case.register(user_params), status: :created
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
        params.require(:user).permit(:username, :password, :password_confirmation, :name, :email, :phone, :document)
    end
  end
    