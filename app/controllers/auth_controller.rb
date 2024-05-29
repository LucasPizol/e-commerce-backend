class AuthController < ApplicationController
  skip_before_action :authorized, only: [:login]
  require './app/usecases/auth_use_case'

  def initialize
    @auth_usecase = AuthUseCase.new
  end

  def login
    begin
      response = @auth_usecase.login(params[:userCredential], params[:password])
      render json: response, status: :ok
    rescue UnauthorizedException => e
      render json: {error: e.message}, status: e.status
    rescue StandardError => e
      render json: {error: e.message}, status: :internal_server_error
    end

  end
  private
end
  