class RegisterUseCase 
    require './app/services/token_service'
    require './app/services/stripe_service'
    require './app/exceptions/bad_request_exception.rb'
    require './app/exceptions/unprocessable_entity_exception.rb'

    def initialize
        @token_service = TokenService.new
        @stripe_service = StripeService.new
    end

    def register(user_params)
        if (user_params[:password] != user_params[:password_confirmation])
            raise UnprocessableEntityException.new("Password and password confirmation don't match")
        end

        user = User.new(user_params)

        begin
            if user.save
                customer = @stripe_service.create_customer(user)

                user.update(stripe_id: customer.id)

                user_object = {
                    id: user.id,
                    name: user.name,
                    email: user.email,
                    phone: user.phone,
                    document: user.document,
                    role: user.role, 
                    stripe_id: customer.id
                }
                
                token = @token_service.encode(user_object)

                return {**user_object, token: token}
            else
                return user.errors
            end
        rescue ActiveRecord::NotNullViolation => e
            raise BadRequestException.new(e.message)
        end
    end
end