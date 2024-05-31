class Order::RetrieveOrderUseCase
    require './app/services/stripe_service'

    def initialize
        @stripe_service = StripeService.new
    end

    def retrieve_order(order_id)
        @stripe_service.retrieve_order(order_id)
    end
end