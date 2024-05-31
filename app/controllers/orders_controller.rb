class OrdersController < ApplicationController
    require './app/use_cases/order/load_orders_use_case'

    def initialize
        @load_orders_use_case = Order::LoadOrdersUseCase.new
    end

    def index
        begin
            render json: @load_orders_use_case.load_orders(@current_user), status: :ok
        rescue BadRequestException => e
            render json: {error: e.message}, status: e.status
        rescue => e
            render json: {error: e.message}, status: :internal_server_error
        end
    end
end