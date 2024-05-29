class AuthController < ApplicationController
  skip_before_action :authorized, only: [:login]

    def login
      user = params[:userCredential].include?('@') ? User.find_by(email: params[:userCredential]) : User.find_by(username: params[:userCredential])

      if user && user.authenticate(params[:password])
        user_object = {id: user.id, name: user.name, email: user.email, phone: user.phone, document: user.document, role: user.role}
        token = encode_token(user_object)
        render json: {**user_object, token: token}, status: :ok
      else
        render json: { error: 'Invalid email or password' }, status: :unauthorized
      end
    end
  
    private
  
    def encode_token(payload)
      JWT.encode(payload, ENV["JWT_SECRET"])
    end
  end
  