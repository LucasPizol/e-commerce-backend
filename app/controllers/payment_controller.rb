class PaymentController < ApplicationController
    require './app/use_cases/payment/checkout_use_case'

    def initialize
        @checkout_use_case = CheckoutUseCase.new
    end

    def checkout
        begin
            render json: @checkout_use_case.checkout(@current_user, params[:line_items]), status: :ok
        rescue BadRequestException => e
            render json: {error: e.message}, status: e.status
        rescue => e
            render json: {error: e.message}, status: :internal_server_error
        end
    end

    def payment_params
        params.permit(:line_items)
    end
end