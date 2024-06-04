class AuthController < ApplicationController
    skip_before_action :authorized, only: [:login, :register]
    before_action :initialize_login_usecase, only: [:login]
    before_action :initialize_register_usecase, only: [:register]
    before_action :initialize_verify_usecase, only: [:verify]
  
    def login
      begin
        response = @login_usecase.login(authorize_user_params[:user_credential], authorize_user_params[:password])
  
        render json: response, status: :ok
      rescue UnauthorizedException => e
        render json: {error: e.message}, status: e.status
      rescue Stripe::StripeError => e
        render json: {error: e.message}, status: :internal_server_error
      rescue StandardError => e
        render json: {error: e.message}, status: :internal_server_error
      end
    end
  
    def register
        begin
          render json: @register_use_case.register(register_user_params), status: :created
        rescue UnprocessableEntityException => e
          render json: {error: e.message}, status: e.status
        rescue BadRequestException => e
          render json: {error: e.message}, status: e.status
        rescue => e
          render json: {error: e.message}, status: :internal_server_error
        end
    end

    def verify
        if @current_user
          data = @verify_user_session_use_case.load(@current_user)
          return render json: data, status: :ok
        end
    
        render json: {error: "Unauthorized"}, status: :unauthorized
    end

    private

    def register_user_params
        params.require(:user).permit(:name, :email, :phone, :document, :password, :password_confirmation)
    end
    
    def authorize_user_params
      params.require(:user).permit(:user_credential, :password)
    end
     
    def initialize_login_usecase
        @login_usecase = Auth::LoginUseCase.new(
            token_service: TokenService.new,
            load_cart_use_case: Cart::LoadCartUseCase.new,
            user_repo: User
        )
    end

    def initialize_register_usecase
        @register_use_case = Auth::RegisterUseCase.new(
            token_service: TokenService.new,
            stripe_service: StripeService.new,
            user_repo: User
        )
    end

    def initialize_verify_usecase
        @verify_user_session_use_case = Auth::VerifyUserSessionUseCase.new(
            load_cart_use_case: Cart::LoadCartUseCase.new
        )
    end
  
  end
    