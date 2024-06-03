class Order::RetrieveOrderController < ApplicationController
    require './app/use_cases/order/load_orders_use_case'
    require './app/use_cases/order/retrieve_order_use_case'

    def initialize
        @retrieve_order_use_case = Order::RetrieveOrderUseCase.new
    end

    def handle
        id = params.permit([:id])[:id]

        begin
            render json: @retrieve_order_use_case.retrieve_order(id), status: :ok
        rescue BadRequestException => e
            render json: {error: e.message}, status: e.status
        rescue => e
            render json: {error: e}, status: :internal_server_error
        end
    end
end