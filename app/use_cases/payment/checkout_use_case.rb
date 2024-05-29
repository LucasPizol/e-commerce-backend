class CheckoutUseCase 

    require './app/services/stripe_service'

    def initialize
        @stripe_service = StripeService.new
    end

    def checkout(user, price_id)
        session = @stripe_service.create_checkout_session(user.stripe_id, price_id)

        return session
    end

end