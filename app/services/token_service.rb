class TokenService 
    def initialize
        @secret_key = ENV["JWT_SECRET"]
        @algorithm = ENV["JWT_HASH_ALGORITHM"]
        if @secret_key.nil? || @algorithm.nil? 
            raise "JWT_SECRET and JWT_HASH_ALGORITHM must be set in .env file"
        end
    end

    def encode(payload)
        JWT.encode(payload, @secret_key)
    end
    
    def decode(token)
        begin
            return JWT.decode(token, @secret_key, true, algorithm: @algorithm)
        rescue JWT::DecodeError
            return nil
        end
    end
end