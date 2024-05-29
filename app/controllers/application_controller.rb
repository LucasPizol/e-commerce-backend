
require 'dotenv'
Dotenv.load

class ApplicationController < ActionController::API
    before_action :authorized


    def authorized
      header = request.headers['Authorization']
      token = header.split(' ')[1] if header

      begin
        decoded = JWT.decode(token, ENV["JWT_SECRET"], true, algorithm: ENV["JWT_HASH_ALGORITHM"])

        id = decoded[0]['id']
        @current_user = User.find(id)
      rescue JWT::DecodeError
        render json: { error: 'Unauthorized' }, status: :unauthorized
      end
    end

    def permission_admin
      if @current_user.role != 'admin'
        raise 'Unauthorized'
      end
    end
end
