class CheckoutUseCase 

    require './app/services/stripe_service'
    require './app/services/token_service'

    def initialize
        @stripe_service = StripeService.new
        @token_service = TokenService.new
    end

    def checkout(user, line_items)

        token = @token_service.encode({
            status: "success",    
        }, 15.minutes.from_now.to_i)

        session = @stripe_service.create_checkout_session(
            user,
            line_items,
            "#{ENV["FRONTEND_URL"]}/checkout?token=#{token}",
            "#{ENV["FRONTEND_URL"]}/checkout"
        )

        return session
    end

end