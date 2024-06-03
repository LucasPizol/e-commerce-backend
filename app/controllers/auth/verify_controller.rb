class Auth::VerifyController < ApplicationController
    def initialize
        @load_cart_use_case = Cart::LoadCartUseCase.new
        @verify_user_session_use_case = Auth::VerifyUserSessionUseCase.new
    end

    def handle
      if @current_user
        data = @verify_user_session_use_case.load(@current_user)
        return render json: data, status: :ok
      end
  
      render json: {error: "Unauthorized"}, status: :unauthorized
    end
end