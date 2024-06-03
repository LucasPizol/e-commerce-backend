class Auth::LoginUseCase 
    def initialize
        @token_service = TokenService.new
        @load_cart_use_case = Cart::LoadCartUseCase.new
        @user_repo = User
    end

    def login(user_credential, password)
        if user_credential.nil? || password.nil?
            raise UnauthorizedException.new 'Invalid email or password'
        end

        user = user_credential.include?('@') ? @user_repo.find_by(email: user_credential) : @user_repo.find_by(username: user_credential)
        
        
        if user && user.authenticate(password)
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
            
            token = @token_service.encode(user_object)

            if (token.nil?)
                raise 'Token could not be generated'
            end

            return ({user: {**user_object, token: token}, cart: cart})
        else
            raise UnauthorizedException.new('Invalid email or password')
        end
    end
end