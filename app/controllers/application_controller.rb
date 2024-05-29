
require 'dotenv'
Dotenv.load

class ApplicationController < ActionController::API
    before_action :authorized

    def authorized
      header = request.headers['Authorization']
      token = header.split(' ')[1] if header

      decoded = TokenService.decode(token)

      if decoded.nil?
        return render json: { error: 'Unauthorized' }, status: :unauthorized
      end

      id = decoded[0]['id']
      @current_user = User.find(id)
    end

    def permission_admin
      if @current_user.role != 'admin'
        raise 'Unauthorized'
      end
    end
end
