class Cart::ClearCartUseCase 
    require "./app/services/token_service"

    def initialize
        @token_service = TokenService.new
    end

    def clear(user_id, token)
        decoded_token = @token_service.decode(token)[0]

        if decoded_token.nil?
            raise BadRequestException.new("Invalid token")
        end
    
        if decoded_token["status"] == "success"
            Cart.all.where(user_id: user_id).destroy_all
        else
            raise BadRequestException.new("Invalid token")
        end
    end
end