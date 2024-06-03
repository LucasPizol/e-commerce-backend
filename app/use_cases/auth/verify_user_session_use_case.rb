class Auth::VerifyUserSessionUseCase
    def initialize
        @load_cart_use_case = Cart::LoadCartUseCase.new
    end


    def load(user)
        cart = @load_cart_use_case.load(user.id)
        
        user_object = {
            id: user.id,
            name: user.name,
            email: user.email,
            phone: user.phone,
            document: user.document,
            role: user.role, 
            stripe_id: user.id
        }

        return {user: user_object, cart: cart}
    end


end