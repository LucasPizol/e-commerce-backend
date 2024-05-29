class BadRequestException < StandardError
    def initialize(msg)
        super(msg)
    end

    def status
        :bad_request
    end
end