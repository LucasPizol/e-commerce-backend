class UnauthorizedException < StandardError
    def initialize(msg)
        super(msg)
    end

    def status
        :unauthorized
    end
end