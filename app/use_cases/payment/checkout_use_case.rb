class CheckoutUseCase 

    require './app/services/stripe_service'
    require './app/services/token_service'

    def initialize
        @stripe_service = StripeService.new
        @token_service = TokenService.new
    end

    def checkout(user, line_items)
        expires_at = 30.minutes.from_now.to_i

        token = @token_service.encode({
            status: "success",
            user: user,
            line_items: line_items  
        }, expires_at)

        session = @stripe_service.create_checkout_session(
            user,
            line_items,
            "#{ENV["FRONTEND_URL"]}/checkout?token=#{token}",
            "#{ENV["FRONTEND_URL"]}/checkout",
            expires_at
        )

        return session
    end

end