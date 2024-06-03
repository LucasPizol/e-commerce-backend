class Order::LoadOrdersController < ApplicationController
    def initialize
        @load_orders_use_case = Order::LoadOrdersUseCase.new
    end

    def handle
        begin
            render json: @load_orders_use_case.load_orders(@current_user), status: :ok
        rescue BadRequestException => e
            render json: {error: e.message}, status: e.status
        rescue => e
            render json: {error: e}, status: :internal_server_error
        end
    end
end