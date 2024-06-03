class Auth::LoginController < ApplicationController
  skip_before_action :authorized, only: [:handle]

  def initialize
    @login_usecase = Auth::LoginUseCase.new
  end

  def handle
    begin
      response = @login_usecase.login(user_params[:user_credential], user_params[:password])

      render json: response, status: :ok
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
  