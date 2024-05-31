class Order::LoadOrdersUseCase 

    require './app/services/stripe_service'

    def initialize
        @stripe_service = StripeService.new
    end


    def load_orders(user)
        @stripe_service.load_orders(user) 
    end
end