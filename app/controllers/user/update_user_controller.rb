class User::UpdateUserController < ApplicationController
    def handle
      if @current_user.update(user_params)
        render json: {
            name: @current_user.name,
            email: @current_user.email,
            phone: @current_user.phone,
            document: @current_user.document,
            username: @current_user.username
        }, status: :ok
          
        
      else
        render json: @current_user.errors, status: :unprocessable_entity
      end
    end
  
    private
      def user_params
        params.require(:user).permit(:username, :password, :password_confirmation, :name, :email, :phone, :document)
      end
  end
  